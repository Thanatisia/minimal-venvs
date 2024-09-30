: "
Proof-of-Concept generic Virtual Environment chroot for various applications

tldr a python virtual environment for various package management development environment
"

# Set Variables

## User Input-accepted
CUSTOM_BASHRC_FILENAME=${CUSTOM_BASHRC_FILENAME:-"custom.bashrc"} # Set the name of the custom .bashrc file
VENV_ROOT_DIR_NAME=${VENV_ROOT_DIR_NAME:-"venv"} # Set the name of the virtual environment's new chroot directory
VENV_ROOT_DIR_PATH=${VENV_ROOT_DIR_PATH:-$PWD} # Set the path of the virtual environment's new chroot directory

## Statically-defined variables
VENV_ROOT_DIR="$VENV_ROOT_DIR_PATH/$VENV_ROOT_DIR_NAME" # Set your root directory for the virtual environment's new chroot

## Associative Arrays (Key-Value Mappings/Dictionary/HashMap/Map)
declare -A VENV_CHROOT_CREATE_CONTENTS=(
    # Specify the directories to be created in the new chroot virtual environment
    # [directory-alias]="path/to/directory" \
    [bin]="$VENV_ROOT_DIR/bin" \
    [etc]="$VENV_ROOT_DIR/etc"
    [var]="$VENV_ROOT_DIR/var"
    [cache]="$VENV_ROOT_DIR/cache"
    [tmp]="$VENV_ROOT_DIR/tmp"
    [GOCACHE]="$VENV_ROOT_DIR/cache/go"
    [GOTMPDIR]="$VENV_ROOT_DIR/tmp/go"
)
declare -A VENV_CHROOT_COPY_DIRS=(
    # Specify the directories to be copied into the new chroot virtual environment
    # [source-directory-path]="destination-directory-path" \
    ["$GOPATH"]="$VENV_ROOT_DIR/go"
)
declare -A VENV_CHROOT_COPY_BIN=(
    # Specify the binaries to be copied into the new chroot virtual environment's 'bin' directory
    # [source-directory-path]="$VENV_ROOT_DIR/bin" \
    ["`which go`"]="$VENV_ROOT_DIR/bin/go"
)
declare -A VENV_CHROOT_ENV=(
    # Specify the Environment Variables to pass in the new chroot virtual environment
    # [var_name]="value" \
    [HOME]=$VENV_ROOT_DIR \
    [PWD]=$VENV_ROOT_DIR \
    [PATH]="${VENV_ROOT_DIR}/go/bin:${VENV_ROOT_DIR}/bin:$PATH" \
    [GOROOT]="$VENV_ROOT_DIR/go" \
    [GOPATH]="$VENV_ROOT_DIR/go" \
    [GOBIN]="$VENV_ROOT_DIR/go/bin" \
    [GOTOOLDIR]="$VENV_ROOT_DIR/go/pkg/tool/windows_amd64"
    [GOCACHE]="$VENV_ROOT_DIR/cache/go"
    [GOTMPDIR]="$VENV_ROOT_DIR/tmp/go"
)
VENV_CHROOT_CMD_EXEC=(
    # Specify the list/array of commands to execute on chroot into the virtual environment session
    # "command" \
    "cd $VENV_ROOT_DIR"
)

## Functions
function create_virtualenv_dirs() {
    : "
    Create virtual environment directories
    "

    # Iterate through the associative array (key-value mappings) containing the directories to create
    for key in "${!VENV_CHROOT_CREATE_CONTENTS[@]}"; do
        value="${VENV_CHROOT_CREATE_CONTENTS[$key]}"

        # Check if directory exists
        if [[ ! -d $value ]]; then
            # Does not exists: Create
            printf "%s : %s\n" $key $value
            mkdir -pv "$value"
        fi
    done
}

## Main body
main() {
    # Get CLI argument parsed
    argv=("$@")
    argc="${#argv[@]}"

    # Create virtual environment directories
    for key in "${!VENV_CHROOT_CREATE_CONTENTS[@]}"; do
        value="${VENV_CHROOT_CREATE_CONTENTS[$key]}"

        # Check if directory exists
        if [[ ! -d $value ]]; then
            # Does not exists: Create
            printf "%s : %s\n" $key $value
            mkdir -pv "$value"
        fi
    done

    # Copy the source directories from the host into the destination directories in the virtual environment container
    for key in "${!VENV_CHROOT_COPY_DIRS[@]}"; do
        value="${VENV_CHROOT_COPY_DIRS[$key]}"

        # Check if directory exists
        if [[ ! -d $value ]]; then
            # Does not exists: Create
            printf "%s => %s\n" $key $value
            cp -r $key $value
        fi
    done

    # Copy the source binary files from the host into the destination ('bin' directory in the virtual environment container)
    for key in "${!VENV_CHROOT_COPY_BIN[@]}"; do
        value="${VENV_CHROOT_COPY_BIN[$key]}"

        # Check if binary exists
        if [[ ! -f $value ]]; then
            # Does not exists: Create
            printf "%s => %s\n" $key $value
            cp -r $key $value
        fi
    done

    # Change root from the original home directory into the root of the virtual environment
    # echo -e "export HOME=$VENV_ROOT_DIR" > $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME
    # echo -e "export PWD=$VENV_ROOT_DIR" >> $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME

    # Create a new .bashrc file
    echo -e "" > $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME

    # Write the new Environment Variables (isolate and point in the chroot environment) into the custom .bashrc file
    for key in "${!VENV_CHROOT_ENV[@]}"; do
        value="${VENV_CHROOT_ENV[$key]}"

        # Write the environment variables into the .bashrc file
        # printf "export %s=%s\n" $key $value >> $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME
        echo -e "export $key=\"$value\"" >> $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME
    done

    # Append final instructions to execute on chroot
    # echo -e "cd $VENV_ROOT_DIR" >> $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME

    # Append list of instructions to execute on chroot
    for i in "${!VENV_CHROOT_CMD_EXEC[@]}"; do
        value="${VENV_CHROOT_CMD_EXEC[$i]}"

        echo -e "[$i] : $value"

        echo -e "$value" >> $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME
    done

    # Jump into the shell using a custom configuration file
    bash --rcfile $VENV_ROOT_DIR/$CUSTOM_BASHRC_FILENAME
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

