module.exports = {
    networks: {
        ganache: {
            host: "localhost",
            port: 7545,
            network_id: "*",
            gas: 4712388
        },
        rinkeby: {
            host: "localhost",
            port: 8545,
            network_id: "4",
            gas: 4712388,
            from: "0x3a980bD986b0E55758151B34A8CE6e32189D35DE"
        }
    }
};