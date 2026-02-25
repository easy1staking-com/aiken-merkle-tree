// /**
//  * This file contains the implementation of a spend_validator function that validates a spend transaction
//  * using a Merkle tree. It also includes a test case for the spend_validator function.
//  */

use aiken_merkle_tree/mt.{Proof, Root, from_list, get_proof, is_member, root}
use cardano/transaction.{OutputReference, Transaction}

pub type MyDatum {
  merkle_root: Root,
}

pub type MyRedeemer {
  my_proof: Proof<ByteArray>,
  user_data: ByteArray,
}

// /**
//  * The spend_validator function validates a spend transaction by checking if the user data is a member of
//  * the Merkle tree with the given Merkle root and proof.
//  *
//  * @param datum - The MyDatum object containing the Merkle root.
//  * @param redeemer - The MyRedeemer object containing the proof and user data.
//  * @param _ctx - The ScriptContext.
//  */
validator markle_sample {
  // fn spend_validator(datum: MyDatum, redeemer: MyRedeemer, _ctx: ScriptContext) {
  spend(
    datum: Option<MyDatum>,
    redeemer: MyRedeemer,
    _own_ref: OutputReference,
    _self: Transaction,
  ) {
    expect Some(my_datum) = datum
    is_member(
      my_datum.merkle_root,
      redeemer.user_data,
      redeemer.my_proof,
      identity,
    )
  }

  else(_) {
    fail
  }
}

// /**
//  * Test case for the spend_validator function.
//  */
test spend_validator_1() {
  let data = ["dog", "cat", "mouse"]
  let merkle_tree = from_list(data, identity)
  let datum = MyDatum { merkle_root: root(merkle_tree) }
  expect Some(proof) = get_proof(merkle_tree, "cat", identity)
  let redeemer = MyRedeemer { my_proof: proof, user_data: "cat" }
  let placeholder_utxo = OutputReference { transaction_id: "", output_index: 0 }
  markle_sample.spend(
    Some(datum),
    redeemer,
    placeholder_utxo,
    transaction.placeholder,
  )
}
