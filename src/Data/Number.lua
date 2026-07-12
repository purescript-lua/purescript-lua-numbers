return {
  nan = (0 / 0),
  isNaN = (function(x) return x ~= x end),
  infinity = (math.huge),
  isFinite = (function(x) return x == x and x ~= math.huge and x ~= -math.huge end),
  abs = (math.abs),
  acos = (math.acos),
  asin = (math.asin),
  atan = (math.atan),
  atan2 = (function(y) return function(x) return math.atan2(y, x) end end),
  ceil = (math.ceil),
  cos = (math.cos),
  exp = (math.exp),
  floor = (math.floor),
  log = (math.log),
  max = (function(n1)
    return function(n2)
      -- JS Math.max returns NaN if either argument is NaN; Lua's math.max
      -- folds with `>` and `nan > x` is false, so it would drop the NaN.
      if n1 ~= n1 or n2 ~= n2 then return 0 / 0 end
      return math.max(n1, n2)
    end
  end),
  min = (function(n1)
    return function(n2)
      if n1 ~= n1 or n2 ~= n2 then return 0 / 0 end
      return math.min(n1, n2)
    end
  end),
  pow = (function(n) return function(p) return math.pow(n, p) end end),
  remainder = (function(n) return function(m) return math.fmod(n, m) end end),
  round = (function(x) return math.floor(x + 0.5) end),
  sign = (function(x)
    -- Return the Number x for NaN and (signed) zero, else -1 / 1. The old
    -- `and`/`or` encoding returned the boolean `true` for x == 0.
    if x ~= x then return x end
    if x == 0 then return x end
    if x < 0 then return -1 end
    return 1
  end),
  sin = (math.sin),
  sqrt = (math.sqrt),
  tan = (math.tan),
  trunc = (function(x) return x < 0 and math.ceil(x) or math.floor(x) end),
  fromStringImpl = (function(str)
    return function(isFinite)
      return function(just)
        return function(nothing)
          -- Mirror JS parseFloat: a leading-numeric prefix is parsed and
          -- trailing junk (and a whitespace prefix) is tolerated. Guard against
          -- a failed parse — the old code wrapped tonumber's nil in Just — and
          -- use the supplied isFinite predicate so non-finite results are Nothing.
          local prefix = str:match("^%s*([%-+]?%d*%.?%d+[eE]?[%-+]?%d*)")
          local x = prefix and tonumber(prefix) or nil
          if x ~= nil and isFinite(x) then return just(x) end
          return nothing
        end
      end
    end
  end)
}
