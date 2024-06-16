//! FLib.Reflection
//! Author : farey0
//!
//! Comptime functions around types

//                               ----------------   Declarations   ----------------

const Self = @This();
const Memory = @import("Memory/Memory.zig");

//                               ----------------      Public      ----------------

// Compare two variables of the same type.
// It calls Struct.Compare for structs, Optional.Compare for optinnals, etc...
//
// It doesn't dereference pointer, it only compares the addresses
pub fn Compare(value1: anytype, value2: anytype) bool {
    if (@TypeOf(value1) != @TypeOf(value2))
        @compileError("value1 and value2 must be of the same type : " ++ @typeName(@TypeOf(value1)) ++ " vs " ++ @typeName(@TypeOf(value2)));

    const TypeInfo = @typeInfo(@TypeOf(value1));

    switch (TypeInfo) {
        .Int, .Bool, .Enum, .Float, .Pointer, .ComptimeInt, .ComptimeFloat => {
            return value1 == value2;
        },
        .Array => {
            return Memory.Compare(TypeInfo.Array.child, value1, value2);
        },
        .Struct => {
            return Struct.Compare(value1, value2);
        },
        .Optional => {
            return Optional.Compare(value1, value2);
        },
        else => @compileError("Unimplemented type : " ++ @typeName(@TypeOf(value1))),
    }

    return true;
}

pub const Struct = struct {
    pub fn Is(comptime T: type) bool {
        const TInfo = @typeInfo(T);

        return TInfo == .Struct;
    }

    // Return the name of the first field in holder having the type toFind
    pub fn FindFirstFieldFromType(comptime toFind: type, comptime holder: type) []const u8 {
        const TInfo = @typeInfo(holder);

        if (TInfo != .Struct)
            @compileError("struct1 is not a struct");

        for (TInfo.Struct.fields) |field| {
            if (field.type == toFind)
                return field.name;
        }

        @compileError("No field found of toFind type");
    }

    pub fn HasFieldOfType(comptime toFind: type, comptime holder: type) bool {
        if (!Is(holder))
            @compileError("T is not a struct");

        const TInfo = @typeInfo(holder);

        for (TInfo.Struct.fields) |field| {
            if (field.type == toFind)
                return true;
        }

        return false;
    }

    pub fn Compare(struct1: anytype, struct2: anytype) bool {
        if (@typeInfo(@TypeOf(struct1)) != .Struct)
            @compileError("struct1 is not a struct");

        if (@TypeOf(struct1) != @TypeOf(struct2))
            @compileError("struct1 and struct2 must be of the same type");

        const TypeInfo = @typeInfo(@TypeOf(struct1)).Struct;

        inline for (TypeInfo.fields) |field| {
            if (!Self.Compare(@field(struct1, field.name), @field(struct2, field.name)))
                return false;
        }

        return true;
    }

    // keeping in case of, but tuple values are embedded in the type ?
    // a simple @typeOf with == should be enough??
    fn CompareTuple(tuple1: anytype, tuple2: anytype) bool {
        const TInfo1 = @typeInfo(@TypeOf(tuple1));
        const TInfo2 = @typeInfo(@TypeOf(tuple2));

        if (TInfo1 != .Struct or TInfo2 != .Struct)
            @compileError("tuple1 or tuple2 is not a struct");

        const Struct1 = TInfo1.Struct;
        const Struct2 = TInfo2.Struct;

        if (Struct1.is_tuple == false or Struct2.is_tuple == false)
            @compileError("tuple1 or tuple2 is not a tuple");

        if (Struct1.fields.len != Struct2.fields.len)
            return false;

        inline for (Struct1.fields, Struct2.fields, 0..) |field1, field2, i| {
            const FInfo1 = @typeInfo(field1.type);
            const FInfo2 = @typeInfo(field2.type);

            if (FInfo1 == .Array and FInfo2 == .Array) {
                if (FInfo1.Array.child != FInfo2.Array.child)
                    return false;

                if (!Memory.Compare(FInfo1.Array.child, tuple1[i], tuple2[i]))
                    return false;
            } else {
                if (field1.type != field2.type)
                    return false;

                if (!Self.Compare(tuple1[i], tuple2[i]))
                    return false;
            }
        }

        return true;
    }
};

pub const Optional = struct {
    pub fn Compare(optional1: anytype, optional2: anytype) bool {
        if (@typeInfo(@TypeOf(optional1)) != .Optional)
            @compileError("struct1 is not a struct");

        if (@TypeOf(optional1) != @TypeOf(optional2))
            @compileError("optional1 and optional2 must be of the same type");

        const isOneSet = optional1 != null;
        const isTwoSet = optional2 != null;

        if (isOneSet != isTwoSet)
            return false
        else if (isOneSet and isTwoSet)
            return Self.Compare(optional1.?, optional2.?)
        else
            return true;
    }
};

pub const Tuple = struct {
    pub fn Is(comptime T: type) bool {
        const TInfo = @typeInfo(T);

        return TInfo == .Struct and TInfo.Struct.is_tuple;
    }
};

pub const Enum = struct {
    pub fn Is(comptime T: type) bool {
        const TInfo = @typeInfo(T);

        return TInfo == .Enum;
    }

    pub fn Type(comptime T: type) type {
        return @typeInfo(T).Enum.tag_type;
    }

    pub fn IsPartOf(comptime T: type, value: anytype) bool {
        const TagType = @typeInfo(T).Enum.tag_type;

        if (@TypeOf(value) != TagType)
            @compileError("value is not of the type of the enum");

        inline for (@typeInfo(T).Enum.fields) |field| {
            if (field.value == value)
                return true;
        }

        return false;
    }
};

//                               ----------------      Tests       ----------------

const Testing = @import("Testing.zig");
const Test = Testing;

// Waiting for https://github.com/ziglang/zig/issues/513
// to implement all compileError testing

test "Compare" {
    const Struct1 = struct {
        a: i32 = 0x65965,
        b: bool = false,
        c: ?*i32 = @ptrFromInt(0x4000),
    };

    const Struct2 = struct {
        a: Struct1 = .{},
        b: Struct1 = .{ .b = true },
        c: bool = false,
    };

    const test1: Struct2 = .{
        .a = .{ .c = @ptrFromInt(0x4004) },
    };

    const test2: Struct2 = .{};
    const test3: Struct2 = .{};

    try Test.Expect(!Compare(test1, test2));
    try Test.Expect(Compare(test3, test2));
}
