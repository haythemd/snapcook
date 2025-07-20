import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:snapcook/screens/recipe/recipe_detail_screen.dart';
import 'package:snapcook/screens/recipe/recipes_screen.dart' hide Recipe;
import 'dart:io';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const CameraHomeTab(),
          RecipeListView(),
          RecipeSingleView(recipe: sampleRecipe),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Media item model
class MediaItem {
  final String path;
  final MediaType type;
  final DateTime timestamp;

  MediaItem({
    required this.path,
    required this.type,
    required this.timestamp,
  });
}

enum MediaType { photo, video }

class CameraHomeTab extends StatefulWidget {
  const CameraHomeTab({Key? key}) : super(key: key);

  @override
  State<CameraHomeTab> createState() => _CameraHomeTabState();
}

class _CameraHomeTabState extends State<CameraHomeTab>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isFlashOn = false;
  int _selectedCameraIndex = 0;

  List<MediaItem> _capturedMedia = [];

  late AnimationController _recordingAnimationController;
  late Animation<double> _recordingAnimation;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _recordingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        await _setupCamera(_cameras![_selectedCameraIndex]);
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error setting up camera: $e');
    }
  }

  Future<void> _takePhoto() async {
    if (!_isCameraInitialized || _cameraController == null) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedMedia.add(MediaItem(
          path: photo.path,
          type: MediaType.photo,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_isCameraInitialized || _cameraController == null || _isRecording) return;

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordingSeconds = 0;
      });

      _recordingAnimationController.repeat(reverse: true);
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingSeconds++;
        });
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_isRecording || _cameraController == null) return;

    try {
      final XFile video = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _capturedMedia.add(MediaItem(
          path: video.path,
          type: MediaType.video,
          timestamp: DateTime.now(),
        ));
      });

      _recordingAnimationController.stop();
      _recordingTimer?.cancel();
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      _isCameraInitialized = false;
    });

    await _cameraController?.dispose();
    await _setupCamera(_cameras![_selectedCameraIndex]);
  }

  void _removeMediaItem(int index) {
    setState(() {
      _capturedMedia.removeAt(index);
    });
  }

  void _submitMedia() {
    // Handle media submission logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Media'),
        content: Text('Submitting ${_capturedMedia.length} media items for recipe analysis...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _capturedMedia.clear();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatRecordingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            Positioned.fill(
              child: _isCameraInitialized
                  ? CameraPreview(_cameraController!)
                  : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

            // Top Controls
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flash Toggle
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Recording Timer
                  if (_isRecording)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                          const SizedBox(width: 8),
                          Text(
                            _formatRecordingTime(_recordingSeconds),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                  // Camera Switch
                  GestureDetector(
                    onTap: _switchCamera,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Media Preview List
            if (_capturedMedia.isNotEmpty)
              Positioned(
                bottom: 180,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _capturedMedia.length,
                    itemBuilder: (context, index) {
                      final media = _capturedMedia[index];
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: media.type == MediaType.photo
                                    ? Image.file(
                                  File(media.path),
                                  fit: BoxFit.cover,
                                )
                                    : Stack(
                                  children: [
                                    Container(
                                      color: Colors.grey[800],
                                      child: const Center(
                                        child: Icon(Icons.play_circle_outline,
                                            color: Colors.white, size: 32),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Remove button
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeMediaItem(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Submit Button
            if (_capturedMedia.isNotEmpty)
              Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: _submitMedia,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    '  Submit  ',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // Capture Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _takePhoto,
                  onLongPressStart: (_) => _startVideoRecording(),
                  onLongPressEnd: (_) => _stopVideoRecording(),
                  child: AnimatedBuilder(
                    animation: _recordingAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isRecording ? _recordingAnimation.value : 1.0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording ? Colors.red : Colors.white,
                            border: Border.all(
                              color: _isRecording ? Colors.red : Colors.white,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: _isRecording ? 30 : 60,
                              height: _isRecording ? 30 : 60,
                              decoration: BoxDecoration(
                                shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                                color: _isRecording ? Colors.white : Colors.transparent,
                                borderRadius: _isRecording ? BorderRadius.circular(4) : null,
                              ),
                              child: Icon(Icons.camera_alt_outlined),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _recordingAnimationController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }
}

// Placeholder tabs
class RecipesTab extends StatelessWidget {
  const RecipesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Recipes Tab',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Browse and discover recipes',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedRecipesTab extends StatelessWidget {
  const SavedRecipesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Saved Recipes Tab',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your favorite saved recipes',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Profile Tab',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your profile and settings',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
final Recipe sampleRecipe = Recipe(
  name: "Spaghetti Carbonara",
  description: "A classic Italian pasta dish with eggs, cheese, pancetta, and pepper. This creamy and delicious comfort food is perfect for dinner and will transport you straight to Rome with every bite.",
  cookingTime: "25 min",
  difficulty: "Medium",
  ingredients: [
    "400g Spaghetti pasta",
    "200g Pancetta or guanciale, diced",
    "4 large eggs",
    "100g Parmesan cheese, grated",
    "2 cloves garlic, minced",
    "Fresh black pepper to taste",
    "Salt for pasta water",
    "2 tbsp olive oil"
  ],
  image: "https://images.unsplash.com/photo-1551892374-ecf8285cf834?w=400",
  steps: [
    "Bring a large pot of salted water to boil and cook spaghetti according to package directions until al dente.",
    "While pasta cooks, heat olive oil in a large skillet over medium heat. Add pancetta and cook until crispy, about 5-7 minutes.",
    "In a bowl, whisk together eggs, grated Parmesan, and a generous amount of black pepper.",
    "Reserve 1 cup of pasta cooking water, then drain the pasta.",
    "Add hot pasta to the skillet with pancetta and toss to combine.",
    "Remove from heat and quickly stir in the egg mixture, adding pasta water as needed to create a creamy sauce.",
    "Serve immediately with extra Parmesan and black pepper."
  ],
  categories: ["Italian", "Pasta", "Dinner", "Comfort Food"],
);