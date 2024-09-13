function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here
function first_then_lower_case(arr, predicate) 
  for _, value in ipairs(arr) do
    if predicate(value) then
      return string.lower(value)
    end
  end
  return nil
end


-- Write your powers generator here
function powers_generator(base, limit)
  local power = 1

  return coroutine.create(function()
      while power <= limit do
          coroutine.yield(power)
          power = power * base
      end
      return nil
  end)
end

-- Write your say function here
function say(s)
  local function inner(next)
      if next == nil then
          return (s:gsub("^%s*(.-)%s*$", "%1"))
      end
      s = s .. " " .. next
      return inner
  end
  return inner
end

-- Write your line count function here
function meaningful_line_count(file_path)
  local file, err = io.open(file_path, "r")
  if not file then
      error("No such file: " .. file_path)
  end

  local count = 0
  for line in file:lines() do
      local trimmed_line = line:match("^%s*(.-)%s*$")  -- Trim whitespace
      if trimmed_line ~= "" and not trimmed_line:match("^#") then
          count = count + 1
      end
  end

  file:close()
  return count
end

-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

-- Constructor
function Quaternion.new(a, b, c, d)
    local self = setmetatable({}, Quaternion)
    self.a = a
    self.b = b
    self.c = c
    self.d = d
    return self
end

-- Coefficients
function Quaternion:coefficients()
    return {self.a, self.b, self.c, self.d}
end

-- Conjugate
function Quaternion:conjugate()
    return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

-- Add two quaternions
function Quaternion:__add(other)
    return Quaternion.new(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)
end

-- Multiply two quaternions
function Quaternion:__mul(other)
    local a1, b1, c1, d1 = self.a, self.b, self.c, self.d
    local a2, b2, c2, d2 = other.a, other.b, other.c, other.d

    return Quaternion.new(
        a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
        a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
        a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
        a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
    )
end

-- String representation
function Quaternion:__tostring()
    local function formatTerm(coef, variable)
        if coef == 0 then return "" end
        if coef > 0 then return string.format(" + %.2f%s", coef, variable) end
        return string.format(" - %.2f%s", -coef, variable)
    end

    local result = string.format("%.2f", self.a)
    result = result .. formatTerm(self.b, "i")
    result = result .. formatTerm(self.c, "j")
    result = result .. formatTerm(self.d, "k")

    return result:gsub("^%s+", "") -- Trim leading whitespace
end
