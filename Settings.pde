public static final PVector SIZE = new PVector(200,400);//PIXELS
public static final int FRAME_RATE = 60;
public static final float MOVE_SPEED = 30;//FRAMES
public static final float MOVE_DURING_MILLS = 1000; //5 seconds
public static final int MILLIS_FOR_MOVE_SPEED = int(MOVE_SPEED/FRAME_RATE*MOVE_DURING_MILLS);
public static final color OPACITY = 25;
public final color MY_MAIN_PANEL_COLOR = color(255,0,0);
public final color OTHER_MAIN_PANEL_COLOR = color(255,0,0);
public final PVector DEFAULT_PANEL_SIZE = new PVector(200,200);

//Life circle of each scene
public final int LIFE_MILLIS_SCENE_WELCOME = 3000;