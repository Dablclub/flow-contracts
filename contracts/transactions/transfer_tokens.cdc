import ExampleToken from 0xb6fba1379cc97f72

transaction(recipient: Address, amount: UFix64) {
    var temporaryVault: @ExampleToken.Vault

    prepare(signer: auth(BorrowValue) &Account) {
        let vaultRef = signer.storage.borrow<auth(ExampleToken.Withdraw) &ExampleToken.Vault>(
            from: ExampleToken.VaultStoragePath
        ) ?? panic(ExampleToken.vaultNotConfiguredError(address: signer.address))

        self.temporaryVault <- vaultRef.withdraw(amount: amount)
    }

    execute {
        let receiverAccount = getAccount(recipient)

        let receiverRef = receiverAccount.capabilities.borrow<&ExampleToken.Vault>(
            ExampleToken.VaultPublicPath
        ) ?? panic(ExampleToken.vaultNotConfiguredError(address: recipient))

        receiverRef.deposit(from: <-self.temporaryVault)
        log("Transfer succeeded!")
    }
} 