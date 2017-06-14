public static final PVector SIZE = new PVector(180,320);//PIXELS
public static final float FULL_SCREEN_PANEL_LENGTH = SIZE.x>SIZE.y?SIZE.y:SIZE.x;
public final PVector DEFAULT_PANEL_SIZE = new PVector(FULL_SCREEN_PANEL_LENGTH,FULL_SCREEN_PANEL_LENGTH);

//Animation
public static final int FRAME_RATE = 60;
public static final float MOVE_SPEED = 30;//FRAMES
public static final float MOVE_DURING_MILLS = 2000; //5 seconds
public static final int MILLIS_FOR_MOVE_SPEED = int(MOVE_SPEED/FRAME_RATE*MOVE_DURING_MILLS);
public static final int BACKSTAGE_POSITION_Z = -200; //all panels are moving from this z deep

//Layout setting
public static final PVector CENTER_POSITION = new PVector(SIZE.x/2,SIZE.y/2);
public static final PVector HORIZONTAL_GOLD_POSITION = new PVector(SIZE.x/8*5,SIZE.y/2);// right side of screen
public static final PVector VERTICAL_GOLD_POSITION = new PVector(SIZE.x/2,SIZE.y/8*5);//bottom side of screen
public static final float MARGIN = SIZE.x > SIZE.y?SIZE.x/8:SIZE.y/8; //the magrin size refers to the single side

//color
public static final color OPACITY = 25;
public final color MY_MAIN_PANEL_COLOR = color(125);
public final color OTHER_MAIN_PANEL_COLOR = color(255,0,0);

//Life circle of each scene
public final int LIFE_MILLIS_SCENE_WELCOME = 3000;
public final int CELL_NUM_OF_FIRST_LEVEL_GAME_PANEL= 3;