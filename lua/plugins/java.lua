return {
    'nvim-java/nvim-java',
    dependencies = {
        {
            'neovim/nvim-lspconfig',
            opts = {
                servers = {
                    jdtls = {
                        settings = {
                            java = {
                                configuration = {
                                    runtimes = {
                                        {
                                            name = 'JavaSE-24',
                                            path = '/Users/chris/.sdkman/candidates/java/current/bin/java',
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
            setup = {
                jdtls = function()
                    require('java').setup {}
                end,
            },
        },
    },
}
