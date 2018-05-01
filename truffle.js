module.exports = {
  solc: {
 optimizer: {
   enabled: true,
   runs: 200
 }
},
   networks: {
   development: {
   host: "localhost",
   from:'0x04a54286f962cd0fa168471f7b016224d9bce46a',
   port: 8545,
   network_id: "987", // Match any network id
   gas: 8985897,

  }
 }
};
