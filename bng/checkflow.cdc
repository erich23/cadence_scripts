import FlowStorageFees from 0xe467b9dd11fa00df //MainNet
//TestNet 0x8c5303eaa26202d6

pub fun main(account_address: Address): String {
		let account = getAccount(account_address)
		let available_capacity = UFix64(account.storageCapacity)
		let storage_used = UFix64(account.storageUsed)
		let used_dec =  UFix64(storage_used/available_capacity)
		let used_percentage = (used_dec * 100.00) 
		let perctange_available = (100.00 - used_percentage)
		return perctange_available.toString()
}