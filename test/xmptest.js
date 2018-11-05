var XMP = artifacts.require("XMP");

contract('XMP', function(accounts) {
    it("should be deployable with a truthy address", function() {
        XMP.deployed().then(xmp => {
            console.log(XMP.address);
            assert.ok(XMP.address);
        });
    });
    it("should put 18,666,666,667 XMP in the first account", function() {
        XMP.deployed().then(xmp => {
            console.log(XMP.getBalance);
            XMP.getBalance(accounts[0]).then(result => {
                console.log(result);
            });
        });
    })
});
