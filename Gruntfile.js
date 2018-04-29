module.exports = function (grunt) {
    // project configuration
    grunt.initConfig({
        exec: {
            // this is to allow oraclized to query our local rpc
            rpc_bridge: 'cd C:/Users/Francis/Desktop/ethereum-bridge & start node bridge -H localhost:7545 -a 1 --dev mode',

            // rpc target
            rpc_ganache: '???', // windows app trouble to start with command line
            rpc_rinkeby: 'start geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0x3a980bD986b0E55758151B34A8CE6e32189D35DE"',

            // truffle compiling and migration
            truffle_compile: 'truffle compile',
            truffle_migrate_ganache: 'truffle migrate --network ganache',
            truffle_migrate_rinkeby: 'truffle migrate --network rinkeby'
        },
        clean: ['./build/contracts', './src/build/contracts']
    });

    // loading tasks
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-exec');

    // tasks
    grunt.registerTask('rpc_bridge', ['exec:rpc_bridge']);
    grunt.registerTask('rpc_ganache', ['exec:rpc_ganache']);
    grunt.registerTask('rpc_rinkeby', ['exec:rpc_rinkeby']);
    grunt.registerTask('deploy_ganache', ['clean', 'exec:truffle_compile', 'exec:truffle_migrate_ganache']);
    grunt.registerTask('deploy_rinkeby', ['clean', 'exec:truffle_compile', 'exec:truffle_migrate_rinkeby']);
};