const types = @import("../Engine/types.zig");

//idle
const idleRight1 = @embedFile("assets/idleRight/idleRight1.png");
const idleRight2 = @embedFile("assets/idleRight/idleRight2.png");
const idleRight3 = @embedFile("assets/idleRight/idleRight3.png");
const idleRight4 = @embedFile("assets/idleRight/idleRight4.png");
const idleRight5 = @embedFile("assets/idleRight/idleRight5.png");
const idleRight6 = @embedFile("assets/idleRight/idleRight6.png");
const idleRight7 = @embedFile("assets/idleRight/idleRight7.png");
const idleRight8 = @embedFile("assets/idleRight/idleRight8.png");
const idleRight9 = @embedFile("assets/idleRight/idleRight9.png");
const idleRight10 = @embedFile("assets/idleRight/idleRight10.png");

pub fn PlayIdleRightGraphic(graphic: *types.Graphic) void {
    graphic.SetAnimationLength(10);
    graphic.LoadAnimationFrame(0, &idleRight1[0], idleRight1.len);
    graphic.LoadAnimationFrame(1, &idleRight2[0], idleRight2.len);
    graphic.LoadAnimationFrame(2, &idleRight3[0], idleRight3.len);
    graphic.LoadAnimationFrame(3, &idleRight4[0], idleRight4.len);
    graphic.LoadAnimationFrame(4, &idleRight5[0], idleRight5.len);
    graphic.LoadAnimationFrame(5, &idleRight6[0], idleRight6.len);
    graphic.LoadAnimationFrame(6, &idleRight7[0], idleRight7.len);
    graphic.LoadAnimationFrame(7, &idleRight8[0], idleRight8.len);
    graphic.LoadAnimationFrame(8, &idleRight9[0], idleRight9.len);
    graphic.LoadAnimationFrame(9, &idleRight10[0], idleRight10.len);
    graphic.SetFPS(10);
    if (!graphic.playing)
        graphic.PlayAnimation();
}

const idleLeft1 = @embedFile("assets/idleLeft/idleLeft1.png");
const idleLeft2 = @embedFile("assets/idleLeft/idleLeft2.png");
const idleLeft3 = @embedFile("assets/idleLeft/idleLeft3.png");
const idleLeft4 = @embedFile("assets/idleLeft/idleLeft4.png");
const idleLeft5 = @embedFile("assets/idleLeft/idleLeft5.png");
const idleLeft6 = @embedFile("assets/idleLeft/idleLeft6.png");
const idleLeft7 = @embedFile("assets/idleLeft/idleLeft7.png");
const idleLeft8 = @embedFile("assets/idleLeft/idleLeft8.png");
const idleLeft9 = @embedFile("assets/idleLeft/idleLeft9.png");
const idleLeft10 = @embedFile("assets/idleLeft/idleLeft10.png");

pub fn PlayIdleLeftGraphic(graphic: *types.Graphic) void {
    graphic.SetAnimationLength(10);
    graphic.LoadAnimationFrame(0, &idleLeft1[0], idleLeft1.len);
    graphic.LoadAnimationFrame(1, &idleLeft2[0], idleLeft2.len);
    graphic.LoadAnimationFrame(2, &idleLeft3[0], idleLeft3.len);
    graphic.LoadAnimationFrame(3, &idleLeft4[0], idleLeft4.len);
    graphic.LoadAnimationFrame(4, &idleLeft5[0], idleLeft5.len);
    graphic.LoadAnimationFrame(5, &idleLeft6[0], idleLeft6.len);
    graphic.LoadAnimationFrame(6, &idleLeft7[0], idleLeft7.len);
    graphic.LoadAnimationFrame(7, &idleLeft8[0], idleLeft8.len);
    graphic.LoadAnimationFrame(8, &idleLeft9[0], idleLeft9.len);
    graphic.LoadAnimationFrame(9, &idleLeft10[0], idleLeft10.len);
    graphic.SetFPS(10);
    if (!graphic.playing)
        graphic.PlayAnimation();
}

//run
const runRight1 = @embedFile("assets/runRight/runRight1.png");
const runRight2 = @embedFile("assets/runRight/runRight2.png");
const runRight3 = @embedFile("assets/runRight/runRight3.png");
const runRight4 = @embedFile("assets/runRight/runRight4.png");
const runRight5 = @embedFile("assets/runRight/runRight5.png");
const runRight6 = @embedFile("assets/runRight/runRight6.png");
const runRight7 = @embedFile("assets/runRight/runRight7.png");
const runRight8 = @embedFile("assets/runRight/runRight8.png");

pub fn PlayRunRightGraphic(graphic: *types.Graphic) void {
    graphic.SetAnimationLength(8);
    graphic.LoadAnimationFrame(0, &runRight1[0], runRight1.len);
    graphic.LoadAnimationFrame(1, &runRight2[0], runRight2.len);
    graphic.LoadAnimationFrame(2, &runRight3[0], runRight3.len);
    graphic.LoadAnimationFrame(3, &runRight4[0], runRight4.len);
    graphic.LoadAnimationFrame(4, &runRight5[0], runRight5.len);
    graphic.LoadAnimationFrame(5, &runRight6[0], runRight6.len);
    graphic.LoadAnimationFrame(6, &runRight7[0], runRight7.len);
    graphic.LoadAnimationFrame(7, &runRight8[0], runRight8.len);
    graphic.SetFPS(10);
    if (!graphic.playing)
        graphic.PlayAnimation();
}

const runLeft1 = @embedFile("assets/runLeft/runLeft1.png");
const runLeft2 = @embedFile("assets/runLeft/runLeft2.png");
const runLeft3 = @embedFile("assets/runLeft/runLeft3.png");
const runLeft4 = @embedFile("assets/runLeft/runLeft4.png");
const runLeft5 = @embedFile("assets/runLeft/runLeft5.png");
const runLeft6 = @embedFile("assets/runLeft/runLeft6.png");
const runLeft7 = @embedFile("assets/runLeft/runLeft7.png");
const runLeft8 = @embedFile("assets/runLeft/runLeft8.png");

pub fn PlayRunLeftGraphic(graphic: *types.Graphic) void {
    graphic.SetAnimationLength(8);
    graphic.LoadAnimationFrame(0, &runLeft1[0], runLeft1.len);
    graphic.LoadAnimationFrame(1, &runLeft2[0], runLeft2.len);
    graphic.LoadAnimationFrame(2, &runLeft3[0], runLeft3.len);
    graphic.LoadAnimationFrame(3, &runLeft4[0], runLeft4.len);
    graphic.LoadAnimationFrame(4, &runLeft5[0], runLeft5.len);
    graphic.LoadAnimationFrame(5, &runLeft6[0], runLeft6.len);
    graphic.LoadAnimationFrame(6, &runLeft7[0], runLeft7.len);
    graphic.LoadAnimationFrame(7, &runLeft8[0], runLeft8.len);
    graphic.SetFPS(10);
    if (!graphic.playing)
        graphic.PlayAnimation();
}

//jump
const jumpRight = @embedFile("assets/jumpRight.png");

pub fn PlayJumpRightGraphic(graphic: *types.Graphic) void {
    graphic.LoadStaticTexture(&jumpRight[0], jumpRight.len);
}

const jumpLeft = @embedFile("assets/jumpLeft.png");

pub fn PlayJumpLeftGraphic(graphic: *types.Graphic) void {
    graphic.LoadStaticTexture(&jumpLeft[0], jumpLeft.len);
}
