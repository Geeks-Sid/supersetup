# shellcheck shell=bash
#These functions load conda whenever their run. Therefore, by defualt only the system python would be active
function activate_conda {
        export PATH="$HOME/miniconda/bin:$PATH"
        # shellcheck disable=SC1091
        . "$HOME/miniconda/etc/profile.d/conda.sh"
        echo "Conda activated"
}
function dl_conda {
        activate_conda
        conda activate dl
}
alias dl=dl_conda
