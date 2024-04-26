_symfony_console_all_commands() {
    local command
    local word_to_evaluate
    local prefix

    # Si le premier mot est "herd", utilisez le deuxième mot
    if [[ "$words[1]" == "herd" ]]; then
        word_to_evaluate="$words[2]"
	prefix="herd "
    # Sinon, utilisez le premier mot
    else
        word_to_evaluate="$words[1]"
    	prefix=""
    fi

    if [ -f "./$word_to_evaluate" ]; then
        command=('php' $word_to_evaluate)
    elif type "$word_to_evaluate" &> /dev/null; then
        command=$word_to_evaluate
    else
        return
    fi

    eval "$prefix$command --raw" | sed 's/:/\\:/g' | sed 's/ \{2,\}/:/g'
}

_symfony_console_describe() {
    local suggestions

    suggestions=("${(@f)$(_symfony_console_all_commands)}")

    _describe -t commands "command subcommand" suggestions
}

tools=("${(@s/ /)SYMFONY_CONSOLE_TOOLS}")

if [ -z "$SYMFONY_CONSOLE_TOOLS" ]; then
    tools=("composer" "artisan" "valet" "envoy" "bin/console")
fi

compdef _symfony_console_describe $tools

