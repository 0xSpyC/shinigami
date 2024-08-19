use shinigami::engine::{Engine, EngineTrait};
use shinigami::stack::ScriptStackTrait;
use shinigami::scriptflags::ScriptFlags;
use core::sha256::compute_sha256_byte_array;

pub fn opcode_sha256(ref engine: Engine) -> Result<(), felt252> {
    let arr = @engine.dstack.pop_byte_array()?;
    let res = compute_sha256_byte_array(arr).span();
    let mut res_bytes: ByteArray = "";
    let mut i: usize = 0;
    while i < res.len() {
        res_bytes.append_word((*res[i]).into(), 4);
        i += 1;
    };
    engine.dstack.push_byte_array(res_bytes);
    return Result::Ok(());
}

pub fn opcode_hash160(ref engine: Engine) -> Result<(), felt252> {
    let m = engine.dstack.pop_byte_array()?;
    let res = compute_sha256_byte_array(@m).span();
    let mut res_bytes: ByteArray = "";
    let mut i: usize = 0;
    while i < res.len() {
        res_bytes.append_word((*res[i]).into(), 4);
        i += 1;
    };
    let h: ByteArray = ripemd160::ripemd160_hash(@res_bytes).into();
    engine.dstack.push_byte_array(h);
    return Result::Ok(());
}

pub fn opcode_hash256(ref engine: Engine) -> Result<(), felt252> {
    let m = engine.dstack.pop_byte_array()?;
    let res = compute_sha256_byte_array(@m).span();
    let mut res_bytes: ByteArray = "";
    let mut i: usize = 0;
    while i < res.len() {
        res_bytes.append_word((*res[i]).into(), 4);
        i += 1;
    };
    let res2 = compute_sha256_byte_array(@res_bytes).span();
    let mut res2_bytes: ByteArray = "";
    let mut j: usize = 0;
    while j < res2.len() {
        res2_bytes.append_word((*res2[j]).into(), 4);
        j += 1;
    };
    engine.dstack.push_byte_array(res2_bytes);
    return Result::Ok(());
}

pub fn opcode_ripemd160(ref engine: Engine) -> Result<(), felt252> {
    let m = engine.dstack.pop_byte_array()?;
    let h: ByteArray = ripemd160::ripemd160_hash(@m).into();
    engine.dstack.push_byte_array(h);
    return Result::Ok(());
}

pub fn opcode_checksig(ref engine: Engine) -> Result<(), felt252> {
    let mut _pkBytes = engine.dstack.pop_byte_array();

    let mut full_sig_bytes = engine.dstack.pop_byte_array().unwrap();
    
    if full_sig_bytes.len() < 1 {
        engine.dstack.push_int(0);
    }

    return Result::Ok(());
}

pub fn opcode_codeseparator(ref engine: Engine) -> Result<(), felt252> {
	engine.last_code_sep += 1;

	// TODO Disable OP_CODESEPARATOR for non-segwit scripts.
	// if engine.witness_program.len() == 0 &&
	// 	engine.has_flag(ScriptFlags::ScriptVerifyConstScriptCode) {

	// 	return Result::Err('opcode_codeseparator:non-segwit');
	// }

    Result::Ok(())
}
