--[[
	Reference
		sys/stat.h
--]]
local ffi = require("ffi")
local bit = require("bit")
local band = bit.band;
local utils = require("libc_utils")


require("alltypes")
require("bits/stat")

local octal = utils.octal;


ffi.cdef[[
int stat(const char *__restrict, struct stat *__restrict);
int fstat(int, struct stat *);
int lstat(const char *__restrict, struct stat *__restrict);
int fstatat(int, const char *__restrict, struct stat *__restrict, int);
int chmod(const char *, mode_t);
int fchmod(int, mode_t);
int fchmodat(int, const char *, mode_t, int);
mode_t umask(mode_t);
int mkdir(const char *, mode_t);
int mknod(const char *, mode_t, dev_t);
int mkfifo(const char *, mode_t);
int mkdirat(int, const char *, mode_t);
int mknodat(int, const char *, mode_t, dev_t);
int mkfifoat(int, const char *, mode_t);

int futimens(int, const struct timespec [2]);
int utimensat(int, const char *, const struct timespec [2], int);
]]

local Constants = {
	S_IFMT   = octal('0170000');
	S_IFSOCK = octal('0140000');
	S_IFLNK	 = octal('0120000');
	S_IFREG  = octal('0100000');
	S_IFBLK  = octal('0060000');
	S_IFDIR  = octal('0040000');
	S_IFCHR  = octal('0020000');
	S_IFIFO  = octal('0010000');
	S_ISUID  = octal('0004000');
	S_ISGID  = octal('0002000');
	S_ISVTX  = octal('0001000');


	S_IRWXU = octal('0700');
	S_IRUSR = octal('0400');
	S_IWUSR = octal('0200');
	S_IXUSR = octal('0100');

	S_IRWXG = octal('0070');
	S_IRGRP = octal('0040');
	S_IWGRP = octal('0020');
	S_IXGRP = octal('0010');

	S_IRWXO = octal('0007');
	S_IROTH = octal('0004');
	S_IWOTH = octal('0002');
	S_IXOTH = octal('0001');



	UTIME_NOW  = 0x3fffffff;
	UTIME_OMIT = 0x3ffffffe;
}

local LIB_c = ffi.load("libc")

local Functions = {
	-- Macros
	S_ISLNK	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFLNK) end;
	S_ISREG	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFREG) end;
	S_ISDIR	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFDIR) end;
	S_ISCHR	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFCHR) end;
	S_ISBLK	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFBLK) end;
	S_ISFIFO	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFIFO) end;
	S_ISSOCK	= function(m) return (band(m, Constants.S_IFMT) == Constants.S_IFSOCK) end;

	-- library functions
	chmod = ffi.C.chmod;
	fchmod = ffi.C.fchmod;
	fchmodat = ffi.C.fchmodat;
--	fstat = ffi.C.fstat;
--	fstatat = ffi.C.fstatat;
	futimens = ffi.C.futimens;
--	lstat = ffi.C.lstat;
	mkdir = ffi.C.mkdir;
	mkdirat = ffi.C.mkdirat;
	mkfifo = ffi.C.mkfifo;
	mkfifoat = ffi.C.mkfifoat;
--	mknod = ffi.C.mknod;
--	mknodat = ffi.C.mknodat;
--	stat = ffi.C.stat;
	umask = ffi.C.umask;
	utimensat = ffi.C.utimensat;
}

local exports = {
	Constants = Constants;
	Functions = Functions;
}

setmetatable(exports, {
	__call = function(self, tbl)
		utils.copyPairs(self.Constants, tbl)
		utils.copyPairs(self.Functions, tbl)

		return self;
	end,

})

return exports
