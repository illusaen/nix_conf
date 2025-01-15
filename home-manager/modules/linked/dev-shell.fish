function create_development_shell
    set --local available_templates (get_directory_names "$NIX_CONF/templates")
    set --local regex "^dev(?<language>$available_templates)\$"
    if string match -rq $regex $argv
        echo "$HOME/.local/bin/scripts/devshell.sh $language"
    else
        echo "$argv template doesn't exist yet." >/dev/stdout
    end
end

function get_directory_names
    set -l dir $argv[1]
    if not test -d $dir
        return
    end

    set -l result ""
    for x in $dir/*
        if test -d $x
            set result "$result|"(basename $x)
        end
    end

    if test -n "$result"
        echo (string trim -c "|" $result)
    end
end
