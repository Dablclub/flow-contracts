import ExampleToken from 0xb6fba1379cc97f72

access(all) fun main(address: Address): String {
    let account = getAccount(address)

    let accountReceiverRef = account.capabilities
        .get<&{ExampleToken.Balance}>(ExampleToken.VaultPublicPath)
        .borrow()
        ?? panic(ExampleToken.vaultNotConfiguredError(address: address))

    return "Balance for "
        .concat(address.toString())
        .concat(": ")
        .concat(accountReceiverRef.balance.toString())
} 