#!/bin/bash

create_folder_if_absent(){
    if ! [[ -d  ~/.TRASH ]]; then 
        mkdir ~/.TRASH
        echo "Created ~/.TRASH folder."        
    fi
}

move_to_trash(){
    if [[ -z "$1" ]]; then
        echo "No file specified."
        return 1
    fi

    for item in "$@"; do
        if [[ -f $item || -d $item ]]; then
            mv $item ~/.TRASH/
            echo "Moved: '$item' to trash."
        else
            echo "Failed: '$item' does not exist."
        fi
    done

}

recover_from_trash(){
    if [[ -z "$1" ]]; then
        echo "No file specified."
        return 1
    fi

    for item in "$@"; do
        if [[ -f ~/.TRASH/$item || -d ~/.TRASH/$item ]]; then
            mv ~/.TRASH/$item ./
            echo "Recovered: '$item' from trash."
        else
            echo "Failed: '$item' does not exist in trash."
        fi
    done
}

trash_size(){
    echo -n "Current amount of trash: "
    du -sh ~/.TRASH | cut -f1
}

empty_trash(){
    rm -rf ~/.TRASH/*
    echo "Trash emptied."
}

list_files_in_trash(){
    cd ~/.TRASH/
    find | sed -e "s/[^\/]*\//--|/g"
}

help(){
    echo -e "-r, --recover \t Recover files from trash."
    echo -e "-s, --size \t Print the size of the trash."
    echo -e "-e, --empty \t Empty all files and folders from trash."
    echo -e "-l, --list \t List all files and folders in trash in a tree structure."
    echo -e "\nExamples:"
    echo -e "trash file1.txt folder \t\t Moves 'file.txt' and 'folder' to trash."
    echo -e "trash -r file.txt folder \t Recovers file.txt' and 'folder' from trash."
}


create_folder_if_absent


case $1 in
    -r|--recover)   shift; recover_from_trash "$@"  ;;
    -s|--size)      trash_size ;;
    -e|--empty)     empty_trash ;;
    -l|--list)      list_files_in_trash ;;
    --help)         help ;;
    -*)             echo "Invalid option: $1"
                    echo "Try 'trash.sh --help' for more information."
                    exit 1 ;;
    *)              move_to_trash "$@" ;;
esac
