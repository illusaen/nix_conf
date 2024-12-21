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
