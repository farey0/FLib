//! FLib.Testing
//! Author : farey0
//!
//! std's testing function but in upper camel case

//                          ----------------   Declarations   ----------------

const testing = @import("std").testing;

//                          ----------------      Public      ----------------

pub const Expect = testing.expect;
pub const ExpectEqualStrings = testing.expectEqualStrings;

pub const ReferenceAll = testing.refAllDecls;
