import ExampleToken from 0xb6fba1379cc97f72

transaction(recipient: Address, amount: UFix64) {
    let mintingRef: &ExampleToken.VaultMinter
    var receiver: Capability<&{ExampleToken.Receiver}>

    prepare(signer: auth(BorrowValue) &Account) {
        self.mintingRef = signer.storage.borrow<&ExampleToken.VaultMinter>(
            from: /storage/CadenceFungibleTokenTutorialMinter
        ) ?? panic(ExampleToken.vaultNotConfiguredError(address: recipient))

        let recipient = getAccount(recipient)
        self.receiver = recipient.capabilities.get<&{ExampleToken.Receiver}>(
            ExampleToken.VaultPublicPath
        )
    }

    execute {
        self.mintingRef.mintTokens(amount: amount, recipient: self.receiver)
        log("Tokens minted and deposited to account ".concat(self.receiver.address.toString()))
    }
} 