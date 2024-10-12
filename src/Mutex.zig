//! FLib.Mutex
//! Author : farey0
//!
//! std's mutex functions but in upper camel case

//                               ----------------   Declarations   ----------------

const Self = @This();

const sMutex = @import("std").Thread.Mutex;

//                              ----------------      Members     ----------------

mutex: sMutex = .{},

//                              ----------------      Public      ----------------

pub fn Lock(self: *Self) void {
    self.mutex.lock();
}

pub fn TryLock(self: *Self) bool {
    return self.mutex.tryLock();
}

pub fn Unlock(self: *Self) void {
    self.mutex.unlock();
}
