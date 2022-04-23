#!/bin/sh
# Install Language Servers for Neovim
# Script has to be called after setting up links

LSP_ROOT="$HOME/.lsp"
NVIM_CONFIG="$HOME/.config/nvim"

# Install Eclipse JDT Language Server
ECLIPSE_LSP="$LSP_ROOT/eclipse.jdt.ls"
if [ ! -d "$ECLIPSE_LSP"  ]; then
    JDTLS_VERSION="0.43.0"
    JDTLS_DATE="201909181008"
    JDTLS_LAUNCHER="1.5.500.v20190715-1310"

    JDTLS_FILE="jdt-language-server-$JDTLS_VERSION-$JDTLS_DATE.tar.gz"
    JDTLS_URL="https://download.eclipse.org/jdtls/milestones/$JDTLS_VERSION/$JDTLS_FILE"
    mkdir -p "$ECLIPSE_LSP"
    cd "$ECLIPSE_LSP"
    curl -L "$JDTLS_URL" -O
    tar xf "$JDTLS_FILE"

    JDTLS_LAUNCHER_FILE="${ECLIPSE_LSP}/plugins/org.eclipse.equinox.launcher_${JDTLS_LAUNCHER}.jar"
    echo "if executable('java') && filereadable(expand('$JDTLS_LAUNCHER_FILE'))
    au User lsp_setup call lsp#register_server({
    \\ 'name': 'eclipse.jdt.ls',
    \\ 'cmd': {server_info->[
    \\     'java',
    \\     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    \\     '-Dosgi.bundles.defaultStartLevel=4',
    \\     '-Declipse.product=org.eclipse.jdt.ls.core.product',
    \\     '-Dlog.level=ALL',
    \\     '-noverify',
    \\     '-Dfile.encoding=UTF-8',
    \\     '-Xmx1G',
    \\     '-jar',
    \\     expand('$JDTLS_LAUNCHER_FILE'),
    \\     '-configuration',
    \\     expand('$ECLIPSE_LSP/config_linux'),
    \\     '-data',
    \\     getcwd()
    \\ ]},
    \\ 'whitelist': ['java'],
    \\ })
    endif" > "$NVIM_CONFIG/eclipse-jdtls.vim"
else
    echo "Eclipse Language Server exists. Skipping"
fi

LOMBOK_FOLDER="$LSP_ROOT/lombok"
if [ ! -f "$LOMBOK_FOLDER/lombok.jar" ]; then
    mkdir -p "$LOMBOK_FOLDER"
    cd "$LOMBOK_FOLDER"
    curl -L https://projectlombok.org/downloads/lombok.jar -O
fi
