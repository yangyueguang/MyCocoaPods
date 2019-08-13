#import "StarsViewController.h"
#import "GVRCardboardView.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "GVRHeadTransform.h"
#import <UIKit/UIKit.h>
#import "GVRVideoView.h"
#import "GVRPanoramaView.h"


@interface PanoramaViewController : UIViewController

@end

@interface PanoramaViewController ()<GVRWidgetViewDelegate>
@property(nonatomic) GVRPanoramaView *panoView;
@property(nonatomic) UIScrollView *scrollView;
@end

@implementation PanoramaViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:self.scrollView];
  self.panoView = [[GVRPanoramaView alloc] init];
  self.panoView.delegate = self;
  self.panoView.enableFullscreenButton = YES;
  self.panoView.enableCardboardButton = YES;
  self.panoView.enableTouchTracking = YES;
  [self.panoView loadImage:[UIImage imageNamed:@"andes.jpg"] ofType:kGVRPanoramaImageTypeStereoOverUnder];
  [self.scrollView addSubview:self.panoView];
  [self.scrollView setAccessibilityIdentifier:@"sampleself.scrollself.view"];
    self.panoView.frame = CGRectMake(16,16,self.view.bounds.size.width - 32,250);
    self.scrollView.contentSize = self.view.bounds.size;
}

#pragma mark - GVRWidgetViewDelegate
- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
  NSLog(@"Loaded panorama image");
}

@end

@interface VideoPlayerViewController : UIViewController
@end

@interface VideoPlayerViewController () <GVRVideoViewDelegate>
@property(nonatomic) BOOL isPaused;
@property(nonatomic) GVRVideoView *videoView;
@end

@implementation VideoPlayerViewController
- (instancetype)init {
  self = [super initWithNibName:nil bundle:nil];
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    self.videoView = [[GVRVideoView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
  self.videoView.delegate = self;
  self.videoView.enableFullscreenButton = YES;
  self.videoView.enableCardboardButton = YES;
  self.videoView.enableTouchTracking = YES;
  self.isPaused = YES;
  NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"congo" ofType:@"mp4"];
  [self.videoView loadFromUrl:[[NSURL alloc] initFileURLWithPath:videoPath]
                   ofType:kGVRVideoTypeStereoOverUnder];
}

#pragma mark - GVRVideoViewDelegate
- (void)widgetViewDidTap:(GVRWidgetView *)widgetView {
  if (self.isPaused) {
    [self.videoView play];
  } else {
    [self.videoView pause];
  }
  self.isPaused = !self.isPaused;
}

- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
  NSLog(@"Finished loading video");
  [self.videoView play];
  self.isPaused = NO;
}

- (void)widgetView:(GVRWidgetView *)widgetView
    didFailToLoadContent:(id)content
        withErrorMessage:(NSString *)errorMessage {
  NSLog(@"Failed to load video: %@", errorMessage);
}

- (void)videoView:(GVRVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
  if (position == videoView.duration) {
    [self.videoView seekTo:0];
    [self.videoView play];
  }
}

@end


#define VERTEX_COUNT 200000

static const char* kVertexShaderString =
"#version 100\n"
"\n"
"uniform mat4 uClipFromEyeMatrix; \n"
"uniform mat4 uHeadFromStartMatrix; \n"
"uniform mat4 uEyeFromHeadMatrix; \n"
"uniform vec3 uOffsetPosition; \n"
"uniform vec3 uOffsetVelocity; \n"
"uniform float uWarpFactorVertex; \n"
"uniform float uBrightness; \n"
"attribute vec3 aVertex; \n"
"attribute vec3 aColor; \n"
"varying vec4 vColor; \n"
"void main(void) { \n"
"  vec3 pos_offset = aVertex + uOffsetPosition + vec3(100.); \n"
"  pos_offset = mod(pos_offset, 200.); \n"
"  pos_offset -= vec3(100.); \n"
"  vec4 pos = vec4(pos_offset, 1.0); \n"
"  if (uWarpFactorVertex > 0. && aColor[0] == 0.) { \n"
"    pos.xyz -= 10. * (uWarpFactorVertex - .5) * uOffsetVelocity; \n"
"  } \n"
"  vec3 color = aColor; \n"
"  color = min(color / (.7 + .3 * uWarpFactorVertex), vec3(1.)); \n"
"  if (uWarpFactorVertex > 0.) { \n"
"    vec3 vel_dir = normalize(uOffsetVelocity); \n"
"    vec3 vel_component = dot(pos.xyz, vel_dir) * vel_dir; \n"
"    vec3 out_component = pos.xyz - vel_component; \n"
"    float dist = length(out_component); \n"
"    float dist_factor = 5. + dist; \n"
"    float warp_factor = pow(uWarpFactorVertex, 2.); \n"
"    dist_factor = \n"
"        ((1. - warp_factor) * dist + warp_factor * dist_factor) / dist; \n"
"    pos.xyz = vel_component + dist_factor * out_component; \n"
"    color *= 1. - .5 * warp_factor; \n"
"  } \n"
"  pos = uHeadFromStartMatrix * pos; \n"
"  pos = uClipFromEyeMatrix * \n"
"      uEyeFromHeadMatrix * pos; \n"
"  float distance_factor = 50. / pos.z; \n"
"  gl_PointSize = clamp(distance_factor, 1., 200.); \n"
"  gl_Position = pos; \n"
"    \n"
"  color *= uBrightness; \n"
"  vColor = \n"
"      vec4(min(distance_factor / 2., 5.) * color, distance_factor) * \n"
"      .1 * clamp(pos.z, 0., 10.); \n"
"}\n";

static const char* kFragmentShaderString =
"#version 100\n"
"\n"
"#ifdef GL_ES\n"
"precision mediump float;\n"
"#endif\n"
"uniform float uWarpFactorFragment; \n"
"varying vec4 vColor;\n"
"\n"
"void main(void) { \n"
"  float blend_factor = clamp((vColor.a - 1.) / 2., 0., 1.); \n"
"  gl_FragColor = vec4(clamp(vColor, vec4(0.), vec4(1.))); \n"
"  float radius_factor = 1.; \n"
"  if (uWarpFactorFragment < .5) { \n"
"    radius_factor = (1. - 2. * abs(gl_PointCoord.x - .5)) * \n"
"                    (1. - 2. * abs(gl_PointCoord.y - .5)); \n"
"  } \n"
"  vec3 star_color = \n"
"      mix(1., radius_factor, blend_factor) * vec3(vColor); \n"
"  gl_FragColor = vec4(clamp(star_color, vec3(0.), vec3(1.)), 0.); \n"
"}\n";

// Flag to control if rendering is performed on a background thread or on the main thread.
static const BOOL kRenderInBackgroundThread = YES;

typedef NS_ENUM(NSUInteger, EngineMode) {
    EngineModeImpulse,
    EngineModeToWarp,
    EngineModeWarp,
    EngineModeToImpulse,
};

static GLuint LoadShader(GLenum type, const char *shader_src) {
    GLint compiled = 0;
    const GLuint shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }
    glShaderSource(shader, 1, &shader_src, NULL);
    glCompileShader(shader);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        GLint info_len = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &info_len);
        if (info_len > 1) {
            char *info_log = ((char *) malloc(sizeof(char) * info_len));
            glGetShaderInfoLog(shader, info_len, NULL, info_log);
            NSLog(@"Error compiling shader:%s", info_log);
            free(info_log);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

@interface StarsRenderLoop : NSObject{
    NSThread *_renderThread;
    CADisplayLink *_displayLink;
    BOOL _paused;
}
- (instancetype)initWithRenderTarget:(id)target selector:(SEL)selector;
- (void)invalidate;
@property(nonatomic) BOOL paused;
@property(nonatomic, readonly) NSTimeInterval nextFrameTime;
@end

@implementation StarsRenderLoop
- (instancetype)initWithRenderTarget:(id)target selector:(SEL)selector {
    if (self = [super init]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:target selector:selector];

        if (kRenderInBackgroundThread) {
            _renderThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(threadMain)
                                                      object:nil];
            [_renderThread start];
        } else {
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)invalidate {
    if (kRenderInBackgroundThread) {
        [self performSelector:@selector(renderThreadStop)
                     onThread:_renderThread
                   withObject:nil
                waitUntilDone:NO];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}
- (BOOL)paused {
    return _paused;
}
- (void)setPaused:(BOOL)paused {
    _paused = paused;
    _displayLink.paused = paused;
}
- (NSTimeInterval)nextFrameTime {
    return _displayLink.timestamp + (_displayLink.duration * _displayLink.frameInterval);
}
- (void)applicationWillResignActive:(NSNotification *)notification {
    if (kRenderInBackgroundThread) {
        [self performSelector:@selector(threadPause)
                     onThread:_renderThread
                   withObject:nil
                waitUntilDone:YES];
    } else {
        [self threadPause];
    }
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    _displayLink.paused = _paused;
}
- (void)threadMain {
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    CFRunLoopRun();
}

- (void)threadPause {
    _displayLink.paused = YES;
}

- (void)renderThreadStop {
    [_displayLink invalidate];
    _displayLink = nil;
    CFRunLoopStop(CFRunLoopGetCurrent());
    dispatch_async(dispatch_get_main_queue(), ^{
        [_renderThread cancel];
        _renderThread = nil;
    });
}

@end

@interface StarsRenderer : NSObject<GVRCardboardViewDelegate>{
    // State for stars.
    GLfloat _vertices[6 * VERTEX_COUNT];
    GLfloat _offset_position[3];
    GLfloat _offset_velocity[3];
    EngineMode _engine_mode;
    GLfloat _warp_factor;
    NSTimeInterval _last_timestamp;
    // Handles to OpenGL variables.
    GLuint _shader_program;
    GLint _projection_matrix;
    GLint _eye_from_head_matrix;
    GLint _head_from_state_matrix;
    GLint _attrib_position;
    GLint _attrib_color;
    GLint _uniform_offset_position;
    GLint _uniform_offset_velocity;
    GLfloat _uniform_warp_factor_vertex;
    GLfloat _uniform_warp_factor_fragment;
    GLfloat _uniform_brightness;
    GLuint _vertex_buffer;
}
@property(nonatomic, weak) StarsRenderLoop *renderLoop;
@end

@implementation StarsRenderer
- (void)cardboardView:(GVRCardboardView *)cardboardView
     prepareDrawFrame:(GVRHeadTransform *)headTransform {
    NSTimeInterval timestep = _renderLoop.nextFrameTime - _last_timestamp;
    if (timestep > 1.0) {
        timestep = 1.0;
    }
    _last_timestamp = _renderLoop.nextFrameTime;
    // Accelerate when our engines are on and we're not in warp mode.
    if (_engine_mode == EngineModeImpulse || _engine_mode == EngineModeToWarp) {
        float thrust_vector[3];
        thrust_vector[0] = 0.0f;
        thrust_vector[1] = 0.0f;
        thrust_vector[2] = 0.02 * (1.0 + 1000.f * _warp_factor) * timestep;
        GLKMatrix4 headPoseInStartSpace = GLKMatrix4Transpose([headTransform headPoseInStartSpace]);
        float *head_matrix = headPoseInStartSpace.m;
        _offset_velocity[0] += thrust_vector[0] * head_matrix[0] +
        thrust_vector[1] * head_matrix[4] +
        thrust_vector[2] * head_matrix[8];
        _offset_velocity[1] += thrust_vector[0] * head_matrix[1] +
        thrust_vector[1] * head_matrix[5] +
        thrust_vector[2] * head_matrix[9];
        _offset_velocity[2] += thrust_vector[0] * head_matrix[2] +
        thrust_vector[1] * head_matrix[6] +
        thrust_vector[2] * head_matrix[10];
    }

    // Slow down if we're not in warp.
    if (_engine_mode != EngineModeWarp) {
        float speed = sqrt(
                           _offset_velocity[0] * _offset_velocity[0] +
                           _offset_velocity[1] * _offset_velocity[1] +
                           _offset_velocity[2] * _offset_velocity[2]);
        float max_speed = .07f + 5.0f * _warp_factor;
        const float drag = 0.995f * (max_speed / fmax(speed, max_speed));
        _offset_velocity[0] *= drag;
        _offset_velocity[1] *= drag;
        _offset_velocity[2] *= drag;
    }
    _offset_position[0] += _offset_velocity[0];
    _offset_position[1] += _offset_velocity[1];
    _offset_position[2] += _offset_velocity[2];
    _offset_position[0] = fmod(_offset_position[0], 200.0f);
    _offset_position[1] = fmod(_offset_position[1], 200.0f);
    _offset_position[2] = fmod(_offset_position[2], 200.0f);
    // Adjust our warp factor if needed.
    if (_engine_mode == EngineModeToWarp) {
        _warp_factor += 0.01f;
        if (_warp_factor >= 1.0) {
            _warp_factor = 1.0f;
            _engine_mode = EngineModeWarp;
        }
    } else if (_engine_mode == EngineModeToImpulse) {
        _warp_factor -= 0.01f;
        if (_warp_factor <= 0.0) {
            _warp_factor = 0.0f;
            _engine_mode = EngineModeImpulse;
        }
    }
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE);
    glDisable(GL_SCISSOR_TEST);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_SCISSOR_TEST);
}

- (void)cardboardView:(GVRCardboardView *)cardboardView
     willStartDrawing:(GVRHeadTransform *)headTransform {
    // Renderer must be created on GL thread before any call to drawFrame.
    // Load the vertex/fragment shaders.
    const GLuint vertex_shader = LoadShader(GL_VERTEX_SHADER, kVertexShaderString);
    NSAssert(vertex_shader != 0, @"Failed to load vertex shader");
    const GLuint fragment_shader = LoadShader(GL_FRAGMENT_SHADER, kFragmentShaderString);
    NSAssert(fragment_shader != 0, @"Failed to load fragment shader");
    // Create the program object.
    _shader_program = glCreateProgram();
    NSAssert(_shader_program != 0, @"Failed to create program");
    glAttachShader(_shader_program, vertex_shader);
    glAttachShader(_shader_program, fragment_shader);
    // Link the shader program.
    glLinkProgram(_shader_program);
    // Get the location of our attributes so we can bind data to them later.
    _attrib_position = glGetAttribLocation(_shader_program, "aVertex");
    NSAssert(_attrib_position != -1, @"glGetAttribLocation failed for aVertex");
    _attrib_color = glGetAttribLocation(_shader_program, "aColor");
    NSAssert(_attrib_position != -1, @"glGetAttribLocation failed for aColor");
    // Check the link status
    GLint linked = 0;
    glGetProgramiv(_shader_program, GL_LINK_STATUS, &linked);
    if (!linked) {
        GLint info_len = 0;
        glGetProgramiv(_shader_program, GL_INFO_LOG_LENGTH, &info_len);
        if (info_len > 1) {
            char* info_log = ((char *) malloc(sizeof(char) * info_len));
            glGetProgramInfoLog(_shader_program, info_len, NULL, info_log);
            NSLog(@"Error linking program: %s", info_log);
            free(info_log);
        }
        glDeleteProgram(_shader_program);
        NSAssert(linked, @"Failed to link program");
    } else {
        // After linking, fetch references to the uniforms in our shader.
        _projection_matrix = glGetUniformLocation(_shader_program, "uClipFromEyeMatrix");
        _eye_from_head_matrix = glGetUniformLocation(_shader_program, "uEyeFromHeadMatrix");
        _head_from_state_matrix = glGetUniformLocation(_shader_program, "uHeadFromStartMatrix");
        _uniform_offset_position = glGetUniformLocation(_shader_program, "uOffsetPosition");
        _uniform_offset_velocity = glGetUniformLocation(_shader_program, "uOffsetVelocity");
        _uniform_warp_factor_vertex = glGetUniformLocation(_shader_program, "uWarpFactorVertex");
        _uniform_warp_factor_fragment = glGetUniformLocation(_shader_program, "uWarpFactorFragment");
        _uniform_brightness = glGetUniformLocation(_shader_program, "uBrightness");
        NSAssert(_projection_matrix != -1 && _eye_from_head_matrix != -1 &&
                 _head_from_state_matrix != -1 && _uniform_offset_position != -1 &&
                 _uniform_offset_velocity != -1 && _uniform_warp_factor_vertex != -1 &&
                 _uniform_warp_factor_fragment != -1 && _uniform_brightness != -1,
                 @"Error fetching uniform values for shader.");
    }
    // Reset state for stars.
    _offset_position[0] = 0.0f;
    _offset_position[1] = 0.0f;
    _offset_position[2] = 0.0f;
    _offset_velocity[0] = 0.0f;
    _offset_velocity[1] = 0.0f;
    _offset_velocity[2] = 0.0f;
    _last_timestamp = 0;
    _engine_mode = EngineModeImpulse;
    _warp_factor = 0.f;
    // Initialize data buffers for vertices. Interlace pos & color.
    srand48(time(0));
    for (int i = 0; i < VERTEX_COUNT; i+=2) {
        _vertices[6 * i + 0] = _vertices[6 * i + 6] = (drand48() * 200) - 100;
        _vertices[6 * i + 1] = _vertices[6 * i + 7] = (drand48() * 200) - 100;
        _vertices[6 * i + 2] = _vertices[6 * i + 8] = (drand48() * 200) - 100;
        _vertices[6 * i + 3] = (float) (drand48() / 2.0f) + 0.5f;
        _vertices[6 * i + 4] = (float) (drand48() / 2.0f) + 0.5f;
        _vertices[6 * i + 5] = (float) (drand48() / 2.0f) + 0.5f;
        _vertices[6 * i +  9] = 0.f;
        _vertices[6 * i + 10] = 0.f;
        _vertices[6 * i + 11] = 0.f;
    }
    glLineWidth(1.f);
    glGenBuffers(1, &_vertex_buffer);
    NSAssert(_vertex_buffer != 0, @"glGenBuffers failed for vertex buffer");
    glBindBuffer(GL_ARRAY_BUFFER, _vertex_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), _vertices, GL_STATIC_DRAW);
}

- (void)cardboardView:(GVRCardboardView *)cardboardView
              drawEye:(GVREye)eye
    withHeadTransform:(GVRHeadTransform *)headTransform {
    CGRect viewport = [headTransform viewportForEye:eye];
    glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
    glScissor(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
    // Get the head matrix.
    const GLKMatrix4 head_from_start_matrix = [headTransform headPoseInStartSpace];
    // Get this eye's matrices.
    GLKMatrix4 projection_matrix = [headTransform projectionMatrixForEye:eye near:0.1f far:100.0f];
    GLKMatrix4 eye_from_head_matrix = [headTransform eyeFromHeadMatrix:eye];
    // Render from this eye.
    [self renderWithProjectionMatrix:projection_matrix.m
                   eyeFromHeadMatrix:eye_from_head_matrix.m
                 headFromStartMatrix:head_from_start_matrix.m];
}

- (void)renderWithProjectionMatrix:(const float *)projection_matrix
                 eyeFromHeadMatrix:(const float *)eye_from_head_matrix
               headFromStartMatrix:(const float *)head_from_state_matrix {
    // Select our shader.
    glUseProgram(_shader_program);
    // Set the uniform values that will be used by our shader.
    glUniform3fv(_uniform_offset_position, 1, _offset_position);
    glUniform3fv(_uniform_offset_velocity, 1, _offset_velocity);
    glUniform1f(_uniform_warp_factor_vertex, _warp_factor);
    glUniform1f(_uniform_warp_factor_fragment, _warp_factor);
    glUniform1f(_uniform_brightness, 1.0f);
    // Set the uniform matrix values that will be used by our shader.
    glUniformMatrix4fv(_projection_matrix, 1, false, projection_matrix);
    glUniformMatrix4fv(_eye_from_head_matrix, 1, false, eye_from_head_matrix);
    glUniformMatrix4fv(_head_from_state_matrix, 1, false, head_from_state_matrix);
    // Draw our polygons.
    glBindBuffer(GL_ARRAY_BUFFER, _vertex_buffer);
    glVertexAttribPointer(_attrib_position, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 6, 0);
    glEnableVertexAttribArray(_attrib_position);
    glVertexAttribPointer(_attrib_color, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 6,
                          (const void*)(sizeof(float) * 3));
    glEnableVertexAttribArray(_attrib_color);
    if (_warp_factor < 0.5f) {
        glDrawArrays(GL_POINTS, 0, VERTEX_COUNT);
    } else {
        glDrawArrays(GL_LINES, 0, VERTEX_COUNT);
    }
    glDisableVertexAttribArray(_attrib_position);
    glDisableVertexAttribArray(_attrib_color);
}

- (void)cardboardView:(GVRCardboardView *)cardboardView
         didFireEvent:(GVRUserEvent)event {
    switch(event) {
        case kGVRUserEventBackButton:NSLog(@"User pressed back button");break;
        case kGVRUserEventTilt:NSLog(@"User performed tilt action");break;
        case kGVRUserEventTrigger:
            switch (_engine_mode) {
                case EngineModeImpulse:
                case EngineModeToImpulse:_engine_mode = EngineModeToWarp;break;
                default:_engine_mode = EngineModeToImpulse;break;
            }break;
    }
}
- (void)cardboardView:(GVRCardboardView *)cardboardView shouldPauseDrawing:(BOOL)pause {
    _renderLoop.paused = pause;
}
@end

@interface StarsViewController () {
  GVRCardboardView *_cardboardView;
  StarsRenderer *_starsRenderer;
  StarsRenderLoop *_renderLoop;
}
@end

@implementation StarsViewController
- (void)loadView {
  _starsRenderer = [[StarsRenderer alloc] init];
  _cardboardView = [[GVRCardboardView alloc] initWithFrame:CGRectZero];
  _cardboardView.delegate = _starsRenderer;
  _cardboardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _cardboardView.vrModeEnabled = YES;
  UITapGestureRecognizer *doubleTapGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapView:)];
  doubleTapGesture.numberOfTapsRequired = 2;
  [_cardboardView addGestureRecognizer:doubleTapGesture];
  self.view = _cardboardView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _renderLoop = [[StarsRenderLoop alloc] initWithRenderTarget:_cardboardView selector:@selector(render)];
  _starsRenderer.renderLoop = _renderLoop;
}
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_renderLoop invalidate];
  _renderLoop = nil;
}
- (void)didDoubleTapView:(id)sender {
  _cardboardView.vrModeEnabled = !_cardboardView.vrModeEnabled;
}
@end
