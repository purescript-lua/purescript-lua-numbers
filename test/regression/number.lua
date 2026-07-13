-- Regression guard for the Lua 5.1 FFI of Data.Number.
-- Expected values come from the Number.purs docstrings = the JS contract.
--
--   #8  isNaN: the FFI key is spelled isNaN (was: isNan, so the export never
--       linked), and NaN is detected via IEEE self-inequality (was: comparing
--       tostring spellings, which are not canonical across signs/libcs).
--   #93 fromStringImpl: Nothing on parse failure (was: Just nil), parseFloat
--       leading-prefix tolerance, and the real isFinite predicate.
--   #94 sign: returns the Number 0 for x == 0 (was: the boolean true).
--   #97 max / #98 min: NaN if EITHER argument is NaN (Lua math.max/min drop it).
--
-- Run from the repo root: `lua test/regression/number.lua`.
local M = assert(dofile("src/Data/Number.lua"))

local failures = 0
local function check(name, cond, detail)
  if cond then
    print("ok   - " .. name)
  else
    failures = failures + 1
    print("FAIL - " .. name .. ": " .. tostring(detail))
  end
end

local nan = 0 / 0
local function isNaN(x) return x ~= x end

-- #8 isNaN
check("isNaN links (key spelled isNaN)", type(M.isNaN) == "function", "type=" .. type(M.isNaN))
check("isNaN NaN", M.isNaN(nan) == true, tostring(M.isNaN(nan)))
check("isNaN -NaN (sign-flipped spelling)", M.isNaN(-nan) == true, tostring(M.isNaN(-nan)))
check("isNaN (inf - inf)", M.isNaN(math.huge - math.huge) == true, tostring(M.isNaN(math.huge - math.huge)))
check("isNaN 0 is false", M.isNaN(0) == false, tostring(M.isNaN(0)))
check("isNaN 1.5 is false", M.isNaN(1.5) == false, tostring(M.isNaN(1.5)))
check("isNaN inf is false", M.isNaN(math.huge) == false, tostring(M.isNaN(math.huge)))
check("isNaN -inf is false", M.isNaN(-math.huge) == false, tostring(M.isNaN(-math.huge)))

-- #94 sign
check("sign 0 is the Number 0 (not a boolean)", type(M.sign(0)) == "number" and M.sign(0) == 0,
      "type=" .. type(M.sign(0)) .. " value=" .. tostring(M.sign(0)))
check("sign -5 == -1", M.sign(-5) == -1, tostring(M.sign(-5)))
check("sign 5 == 1", M.sign(5) == 1, tostring(M.sign(5)))
check("sign NaN is NaN", isNaN(M.sign(nan)), tostring(M.sign(nan)))

-- #97 max / #98 min
check("max 1 NaN is NaN", isNaN(M.max(1)(nan)), tostring(M.max(1)(nan)))
check("max NaN 1 is NaN", isNaN(M.max(nan)(1)), tostring(M.max(nan)(1)))
check("max 3 7 == 7", M.max(3)(7) == 7, tostring(M.max(3)(7)))
check("min 1 NaN is NaN", isNaN(M.min(1)(nan)), tostring(M.min(1)(nan)))
check("min NaN 1 is NaN", isNaN(M.min(nan)(1)), tostring(M.min(nan)(1)))
check("min 3 7 == 3", M.min(3)(7) == 3, tostring(M.min(3)(7)))

-- #93 fromString. fromStringImpl is declared `Fn4`, so the Lua entry is a
-- 4-ary function called with all arguments at once (`runFn4` and the
-- compiler's uncurried lift both call it that way).
local function just(x) return {tag = "just", value = x} end
local nothing = {tag = "nothing"}
local function fromString(s) return M.fromStringImpl(s, M.isFinite, just, nothing) end
local function isJust(m, v) return type(m) == "table" and m.tag == "just" and m.value == v end
local function isNothing(m) return type(m) == "table" and m.tag == "nothing" end

check("fromString '123' == Just 123", isJust(fromString("123"), 123), "")
check("fromString '12.34' == Just 12.34", isJust(fromString("12.34"), 12.34), "")
check("fromString '1e4' == Just 10000", isJust(fromString("1e4"), 10000), "")
check("fromString '1.2e4' == Just 12000", isJust(fromString("1.2e4"), 12000), "")
check("fromString 'bad' == Nothing (not Just nil)", isNothing(fromString("bad")),
      "tag=" .. tostring(type(fromString("bad")) == "table" and fromString("bad").tag))
check("fromString '' == Nothing", isNothing(fromString("")), "")
check("fromString '  1.2 ??' == Just 1.2 (parseFloat prefix)", isJust(fromString("  1.2 ??"), 1.2), "")

if failures > 0 then error(failures .. " regression check(s) failed") end
print("purescript-lua-numbers (Number): all FFI regression checks passed")
