import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 인사말 + 오늘 수련 상태
                _buildGreetingSection(),
                const SizedBox(height: 24),

                // 2. 인기 아사나 TOP 3
                _buildPopularAsanasSection(),
                const SizedBox(height: 24),

                // 3. 이번 주 수련 현황
                _buildWeeklyProgressSection(),
                const SizedBox(height: 24),

                // 4. 즐겨찾는/최근 수련 아사나
                _buildFavoriteAsanasSection(),
                const SizedBox(height: 24),

                // 5. 내 주변 요가원
                _buildNearbyStudiosSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    // TODO: 실제 사용자 데이터와 수련 기록 연동
    final hasTodayRecord = false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF23252B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JUJO님, 오늘도 나를 위한 요가 한 세션 어떠세요?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (hasTodayRecord)
            Row(
              children: [
                const Text('오늘 나무자세를 수련했어요. 수고했어요!', style: TextStyle(color: Colors.white70)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('기록 보기', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {},
              child: const Text('수련 기록하기', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildPopularAsanasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🔥 인기 아사나 TOP 3',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('더보기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FlutterCarousel(
          items: [1, 2, 3].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23252B),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'text $i',
                      style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF23252B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 이번 주 수련 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['월', '화', '수', '목', '금', '토', '일'].map((day) {
              return Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(day, style: const TextStyle(color: Colors.white70)),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            '3일 연속 수련 중이에요!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteAsanasSection() {
    final hasFavorites = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌱 즐겨찾는 아사나',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        if (hasFavorites)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFF23252B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('즐겨찾기 준비 중...', style: TextStyle(color: Colors.white)),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF23252B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('마음에 드는 아사나를 찜해보세요!', style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _buildNearbyStudiosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📍 내 주변 요가원',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('전체 보기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xFF23252B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('요가원 정보 준비 중...', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
} 