local actors = {}

actors['skeleton'] = {
  faction="foe",
  inv={"bones"},
  name="skeleton",
  sheetX=3,
  sheetY=2,
}

actors['goo'] = {
  faction="foe",
  inv={'grey matter'},
  name="goo",
  sheetX=1,
  sheetY=2,
}

actors['fairy'] = {
  faction="foe",
  inv={'magic dust'},
  name="fairy",
  sheetX=1,
  sheetY=3,
} 

actors['key golem'] = {
  faction="ally",
  inv={'key'},
  name="key golem",
  sheetX=3,
  sheetY=3,
}

return actors