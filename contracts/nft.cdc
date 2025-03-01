access(all) contract BasicNFT {

    // Counter for NFT IDs
    access(contract) var counter: UInt64

    // NFT resource
    access(all) resource NFT {
        access(all) let id: UInt64
        access(all) var metadata: {String: String}

        init(initID: UInt64, initDescription: String) {
            self.id = initID
            self.metadata = {"description": initDescription}
        }
    }

    // Function to mint new NFTs
    access(all) fun mintNFT(description: String): @NFT {
        self.counter = self.counter + 1
        return <- create NFT(initID: self.counter, initDescription: description)
    }

    init() {
        self.counter = 0

        // Create and save the first NFT for the contract owner
        self.account.storage.save(
            <-self.mintNFT(description: "First one for me!"), 
            to: /storage/BasicNFTPath
        )

        // Create and publish a capability for the NFT
        let capability = self.account.capabilities.storage
            .issue<&NFT>(/storage/BasicNFTPath)

        self.account.capabilities.publish(
            capability, 
            at: /public/BasicNFTPath
        )
    }
} 