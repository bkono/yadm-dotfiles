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

-- Define a table with body and command functions
local modelCommands = {
  ["groq"] = function(options)
    local new_body = { model = "llama3-70b-8192", max_tokens = 1024, temperature = 0.4, top_p = 1, stop = nil }
    options.body = options.body or {}
    for k, v in pairs(new_body) do
      options.body[k] = v
    end
    print(vim.inspect(options))
    local api_url = "https://api.groq.com"
    local api_endpoint = api_url .. "/openai/v1/chat/completions"
    local api_key_path = "~/.groq/creds"
    local api_key = get_api_key(api_key_path)
    local curl_cmd = "curl --silent --no-buffer -X POST"
    local header_options = "-H 'Authorization: Bearer " .. api_key .. "'"
    return curl_cmd .. " " .. header_options .. " " .. api_endpoint .. " -d $body"
  end,
  ["mistral:instruct"] = function(options)
    local new_body = { model = options.model, stream = true }
    options.body = options.body or {}
    for k, v in pairs(new_body) do
      options.body[k] = v
    end
    print(vim.inspect(options))
    return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
  end,
  -- Add more models as needed
}

return {
  {
    "David-Kunz/gen.nvim",
    config = function()
      require("gen").setup({
        model = "mistral:instruct", -- The default model to use.
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        quit_map = "q", -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        init = function(options)
          pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = function(options)
          print("in the command func")
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

      require("gen").prompts["Groq Ask"] = {
        model = "groq",
        prompt = "Regarding the following text, $input:\n$text",
      }
    end,
  },
}
