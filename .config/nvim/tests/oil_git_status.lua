vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.config/nvim")
local parse = require("dotfiles.utils.oil_git_status").parse
local checked = 0
local function check(records, prefix, expected)
  local actual = parse(records, prefix)
  assert(vim.deep_equal(actual, expected), vim.inspect({ actual = actual, expected = expected }))
  checked = checked + 1
end
for _, xy in ipairs({ " M", "M ", "MM", "A ", "AM", "AD", " D", "D ", " T", "T ", "??" }) do
  check(xy .. " nested/file\0", "nested/", {
    file = { index = xy == "??" and " " or xy:sub(1, 1), working = xy == "??" and "?" or xy:sub(2, 2) },
  })
end
for _, xy in ipairs({ "DD", "AU", "UD", "UA", "DU", "AA", "UU" }) do
  check(xy .. " file\0", "", { file = { index = "U", working = "U" } })
end
for _, index in ipairs({ "M", "T", "A", "R", "C" }) do
  for _, working in ipairs({ " ", "M", "T", "D" }) do
    local records = index .. working .. " nested/file\0"
    if index == "R" or index == "C" then
      records = records .. "nested/old\0"
    end
    check(records, "nested/", { file = { index = index, working = working } })
  end
end
check("R  new-dir/new\0old-dir/old\0", "", {
  ["new-dir"] = { index = "R", working = " " },
  ["old-dir"] = { index = "D", working = " " },
})
check("R  nested/new\0nested/old\0", "nested/", { new = { index = "R", working = " " } })
check("C  nested/copy\0nested/source\0", "nested/", { copy = { index = "C", working = " " } })
check("M  dir/one\0 M dir/two\0", "", { dir = { index = "M", working = "M" } })
check("A  dir/one\0D  dir/two\0", "", { dir = { index = "M", working = " " } })
check("M  dir/one\0UU dir/two\0", "", { dir = { index = "U", working = "U" } })
check("D  recreated\0?? recreated\0", "", { recreated = { index = "D", working = "?" } })
check("?? recreated\0D  recreated\0", "", { recreated = { index = "D", working = "?" } })
for _, name in ipairs({ "日本語", "space name", 'quote"name', "tab\tname", "newline\nname", "slash\\name" }) do
  check(" M " .. name .. "\0", "", { [name] = { index = " ", working = "M" } })
end
check("", "", {})
print("Oil Git parser: " .. checked .. " cases passed")
