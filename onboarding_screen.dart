import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        pages: [
          OnboardingPageModel(
            title: 'Nhanh Chóng & Hiệu Quả',
            description: 'Kiểm soát mọi công việc dễ dàng ngay trong tầm tay.',
            imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
            bgColor: Colors.indigo,
          ),
          OnboardingPageModel(
            title: 'Luôn Kết Nối Với Kế Hoạch',
            description: 'Sắp xếp và theo dõi công việc mọi lúc, mọi nơi.',
            imageUrl: 'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
            bgColor: const Color(0xff1eb090),
          ),
          OnboardingPageModel(
            title: 'Lưu Giữ Ưu Tiên',
            description: 'Đánh dấu nhiệm vụ quan trọng để không bỏ lỡ bất kỳ điều gì.',
            imageUrl: 'https://i.ibb.co/420D7VP/building.png',
            bgColor: const Color(0xfffeae4f),
          ),
          OnboardingPageModel(
            title: 'Chinh Phục Mục Tiêu',
            description: 'Theo dõi tiến độ để hoàn thành công việc đúng hạn.',
            imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
            bgColor: Colors.purple,
          ),
        ],
        onSkip: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
        onFinish: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter({
    super.key,
    required this.pages,
    this.onSkip,
    this.onFinish,
  });

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.network(item.imageUrl),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  item.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: item.textColor,
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: item.textColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map(
                      (item) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentPage == widget.pages.indexOf(item)
                            ? 30
                            : 8,
                        height: 8,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        widget.onSkip?.call();
                      },
                      child: const Text("Skip"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          widget.onFinish?.call();
                        } else {
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "Finish"
                                : "Next",
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == widget.pages.length - 1
                                ? Icons.done
                                : Icons.arrow_forward,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}