require'which-key'.setup{
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,
}
