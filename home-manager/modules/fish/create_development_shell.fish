function create_development_shell
    set --local available_templates (get_directory_names "$NIX_CONF/templates")
    set --local regex "^dev(?<language>$available_templates)\$"
    if string match -rq $regex $argv
        echo "$HOME/.local/bin/scripts/devshell.sh $language"
    else
        echo "$argv template doesn't exist yet." >/dev/stdout
    end
end
