local get_api_key = function(path)
  local expanded_path = vim.fn.expand(path)
  local file = io.open(expanded_path, "r")
  if file then
    local content = file:read("*all"):gsub("\n", "")
    file:close()
    return content
  else
    error("Could not open file!")
  end
end

-- local default_model = "mistral:instruct"
local default_model = "phi3:instruct"

local function merge_options(defaults, options)
  options.body = options.body or {}
  for k, v in pairs(defaults) do
    options.body[k] = v
  end
  print(vim.inspect(options))
end

local function build_curl_command(api_key, api_endpoint, extra_headers)
  local curl_cmd = "curl --silent --no-buffer -X POST"
  local header_options = "-H 'Authorization: Bearer " .. api_key .. "'"
  if extra_headers then
    header_options = header_options .. " " .. extra_headers
  end
  return curl_cmd .. " " .. header_options .. " " .. api_endpoint .. " -d $body"
end

local function get_api_details(api_url, api_key_path)
  local api_key = get_api_key(api_key_path)
  return api_key, api_url
end

local modelCommands = {
  ["groq"] = function(options)
    local new_body = { model = "llama3-70b-8192", max_tokens = 1024, temperature = 0.4, top_p = 1, stop = nil }
    merge_options(new_body, options)
    local api_key, api_url = get_api_details("https://api.groq.com", "~/.groq/creds")
    local api_endpoint = api_url .. "/openai/v1/chat/completions"
    return build_curl_command(api_key, api_endpoint)
  end,
  ["gpt4o"] = function(options)
    local new_body = { model = "gpt-4o", max_tokens = 1024, temperature = 0.4, top_p = 1 }
    merge_options(new_body, options)
    local api_key, api_url = get_api_details("https://api.openai.com", "~/.openai/creds")
    local api_endpoint = api_url .. "/v1/chat/completions"
    return build_curl_command(api_key, api_endpoint, "-H 'Content-Type: application/json'")
  end,
  [default_model] = function(options)
    local new_body = { model = options.model, stream = true }
    merge_options(new_body, options)
    return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
  end,
  -- Add more models as needed
}

return {
  {
    "David-Kunz/gen.nvim",
    config = function()
      local g = require("gen")

      g.setup({
        model = default_model, -- The default model to use.
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        quit_map = "q", -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        init = function(_)
          pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = function(options)
          local commandFunction = modelCommands[options.model]

          if not commandFunction then -- check if command function for given model exists
            return commandFunction["mistral:instruct"]
          end

          return commandFunction(options)
        end,
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        debug = false, -- Prints errors and the command which is run.
      })

      g.prompts["groq:Ask"] = {
        model = "groq",
        prompt = "Regarding the following text, $input:\n$text",
      }

      g.prompts["groq:Chat"] = {
        model = "groq",
        prompt = "$input",
      }

      g.prompts["gpt4o:Ask"] = {
        model = "gpt4o",
        prompt = "Regarding the following text, $input:\n$text",
      }

      g.prompts["gpt4o:Chat"] = {
        model = "gpt4o",
        prompt = "$input",
      }

      g.prompts["Commit Message"] = {
        prompt = function(content, filetype)
          local git_diff = vim.fn.system({ "git", "diff", "--staged" })

          if not git_diff:match("^diff") then
            error("Git error:\n" .. git_diff)
          end

          return "Write a terse commit message according to the Conventional Commits specification. Try to stay below 80 characters total. ONLY reply with the commit message and nothing else. Staged git diff: ```"
            .. git_diff
            .. "\n```"
        end,
        replace = true,
        model = "groq",
      }
    end,
    keys = {
      {
        "<leader>]",
        ":Gen<cr>",
        desc = "Show Menu",
        mode = { "n", "v", "x" },
      },
      {
        "gk",
        ":Gen<cr>",
        desc = "Show Menu",
        mode = { "n", "v", "x" },
      },
    },
  },
}
