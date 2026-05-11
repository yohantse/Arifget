import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../core/models/job.dart';

class JobsListingPage extends StatefulWidget {
  const JobsListingPage({super.key});

  @override
  State<JobsListingPage> createState() => _JobsListingPageState();
}

class _JobsListingPageState extends State<JobsListingPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Job> _jobs = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  int _activeTabIndex = 0; // 0 = Find Jobs, 1 = Best Matches

  @override
  void initState() {
    super.initState();
    _fetchInitialJobs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialJobs() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await ApiService.getJobs();
      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onRefresh() async {
    await _fetchInitialJobs();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && !_isFetchingMore) {
      _fetchMoreJobs();
    }
  }

  Future<void> _fetchMoreJobs() async {
    setState(() => _isFetchingMore = true);
    // Mocking pagination delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      final moreJobs = await ApiService.getJobs(); 
      if (mounted) {
        setState(() {
          _jobs.addAll(moreJobs);
          _isFetchingMore = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isFetchingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF14A800),
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Sticky Header
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 16,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(color: const Color(0xFFE5E7EB), height: 1),
                ),
                title: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Mock avatar
                      backgroundColor: Color(0xFFE5E7EB),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Jobs',
                      style: TextStyle(color: Color(0xFF111827), fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Color(0xFF111827)),
                    onPressed: () {},
                  ),
                ],
              ),

              // Search and Tabs
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchTabsDelegate(
                  searchController: _searchController,
                  activeTabIndex: _activeTabIndex,
                  onTabChanged: (index) {
                    setState(() => _activeTabIndex = index);
                  },
                ),
              ),

              // Content List
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                sliver: _isLoading
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => const _JobCardSkeleton(),
                          childCount: 4,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == _jobs.length) {
                              return _isFetchingMore
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 24),
                                      child: Center(child: CircularProgressIndicator(color: Color(0xFF14A800))),
                                    )
                                  : const SizedBox.shrink();
                            }
                            return _JobCard(job: _jobs[index]);
                          },
                          childCount: _jobs.length + (_isFetchingMore ? 1 : 0),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchTabsDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final int activeTabIndex;
  final Function(int) onTabChanged;

  _SearchTabsDelegate({
    required this.searchController,
    required this.activeTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Bar Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.search, color: Color(0xFF6B7280), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: 'Search for jobs',
                              hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF14A800)),
                  ),
                  child: const Icon(Icons.tune, color: Color(0xFF14A800), size: 20),
                ),
              ],
            ),
          ),
          
          // Tabs Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                _buildTab('Find Jobs', 0),
                const SizedBox(width: 32),
                _buildTab('Best Matches', 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isActive = activeTabIndex == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF14A800) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? const Color(0xFF111827) : const Color(0xFF6B7280),
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 114.0;

  @override
  double get minExtent => 114.0;

  @override
  bool shouldRebuild(covariant _SearchTabsDelegate oldDelegate) {
    return activeTabIndex != oldDelegate.activeTabIndex;
  }
}

class _JobCard extends StatelessWidget {
  final Job job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    // Mocked data for UI richness
    final List<String> mockSkills = ['Figma', 'UI Design', 'Adobe Premiere Pro', 'Motion Graphics'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Time & Proposals + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Posted 1 hour ago • Proposals: 10 to 15',
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Icon(Icons.thumb_down_outlined, color: Color(0xFF6B7280), size: 18),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Icon(Icons.favorite_border, color: Color(0xFF6B7280), size: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Job Title
          Text(
            job.title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          
          // Info Row
          Text(
            '${job.budgetAmount != null && job.budgetAmount! > 0 ? 'Fixed-price' : 'Hourly'} • ${job.experienceLevel ?? 'Intermediate'} • Budget: \$${job.budgetAmount?.toStringAsFixed(0) ?? '100'}',
            style: const TextStyle(color: Color(0xFF4B5563), fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          
          // Description Preview
          RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF111827), fontSize: 14, height: 1.5),
              children: [
                TextSpan(text: job.description),
                const TextSpan(
                  text: ' ...More',
                  style: TextStyle(color: Color(0xFF14A800), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Skills Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mockSkills.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                skill,
                style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12, fontWeight: FontWeight.w600),
              ),
            )).toList(),
          ),
          const SizedBox(height: 24),
          
          // Client Info Section
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.blue, size: 16),
              const SizedBox(width: 4),
              const Text('Payment verified', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              Row(
                children: const [
                  Icon(Icons.star, color: Color(0xFF14A800), size: 14),
                  Icon(Icons.star, color: Color(0xFF14A800), size: 14),
                  Icon(Icons.star, color: Color(0xFF14A800), size: 14),
                  Icon(Icons.star, color: Color(0xFF14A800), size: 14),
                  Icon(Icons.star_half, color: Color(0xFF14A800), size: 14),
                  SizedBox(width: 4),
                  Text('4.8', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(width: 12),
              const Text('\$10K+ spent', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.location_on_outlined, color: Color(0xFF6B7280), size: 16),
              SizedBox(width: 4),
              Text('United States', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(width: 16),
              Text('80% hire rate', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(width: 16),
              Text('25 jobs posted', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Bottom Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14A800),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Icon(Icons.favorite_border, color: Color(0xFF14A800), size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Simple Skeleton Loader for Jobs
class _JobCardSkeleton extends StatefulWidget {
  const _JobCardSkeleton();

  @override
  State<_JobCardSkeleton> createState() => _JobCardSkeletonState();
}

class _JobCardSkeletonState extends State<_JobCardSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Opacity(
            opacity: _animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 150, height: 12, color: const Color(0xFFE5E7EB)),
                    Container(width: 60, height: 24, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(12))),
                  ],
                ),
                const SizedBox(height: 20),
                Container(width: double.infinity, height: 24, color: const Color(0xFFE5E7EB)),
                const SizedBox(height: 8),
                Container(width: 200, height: 24, color: const Color(0xFFE5E7EB)),
                const SizedBox(height: 20),
                Container(width: double.infinity, height: 16, color: const Color(0xFFE5E7EB)),
                const SizedBox(height: 8),
                Container(width: double.infinity, height: 16, color: const Color(0xFFE5E7EB)),
                const SizedBox(height: 8),
                Container(width: 150, height: 16, color: const Color(0xFFE5E7EB)),
                const SizedBox(height: 24),
                Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(24))),
              ],
            ),
          ),
        );
      },
    );
  }
}
