# Move Legality Brainstorming

Scratchwork for how to validate moves

Initial idea:

if inCheck
  has to remove check to be valid (how to calcuate determined later)
else
  get piece
  manually enumerate moves in all legal directions
  filter out illegal moves (blinded, don't check for check yet)
  if would be in check, start all of this over

