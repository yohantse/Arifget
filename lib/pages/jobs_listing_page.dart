import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../core/models/job.dart';
import '../core/constants/colors.dart';
import 'job_details_page.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

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
  int _currentPage = 1;
  bool _hasMore = true;

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
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMore = true;
    });
    try {
      final jobs = await ApiService.getJobs(
        query: _searchController.text,
        page: _currentPage,
      );
      setState(() {
        _jobs = jobs;
        _isLoading = false;
        if (jobs.length < 10) _hasMore = false; // Assuming limit is 10
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onRefresh() async {
    await _fetchInitialJobs();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        !_isFetchingMore &&
        _hasMore) {
      _fetchMoreJobs();
    }
  }

  Future<void> _fetchMoreJobs() async {
    setState(() => _isFetchingMore = true);
    try {
      _currentPage++;
      final moreJobs = await ApiService.getJobs(
        query: _searchController.text,
        page: _currentPage,
      );
      if (mounted) {
        setState(() {
          if (moreJobs.isEmpty) {
            _hasMore = false;
          } else {
            _jobs.addAll(moreJobs);
          }
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
          color: AppColors.primary,
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
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Mock avatar
                        backgroundColor: Color(0xFFE5E7EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Find Work',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                  onSearch: _fetchInitialJobs,
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
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
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

  final VoidCallback onSearch;

  _SearchTabsDelegate({
    required this.searchController,
    required this.activeTabIndex,
    required this.onTabChanged,
    required this.onSearch,
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
                            onSubmitted: (_) => onSearch(),
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
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.primary,
                    size: 20,
                  ),
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
              color: isActive ? AppColors.primary : Colors.transparent,
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

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Recent';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = _getTimeAgo(job.createdAt);
    final proposals = (job.id.hashCode % 15) + 5;
    final skills = ['Ethiopia', 'Freelance', 'Remote'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(
              title: job.title,
              budget: job.budgetAmount ?? 0,
              description: job.description,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted $timeAgo • Proposals: $proposals to ${proposals + 5}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.favorite_border,
                  color: AppColors.primary,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              job.title,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${job.budgetType ?? 'Fixed-price'} - ${job.experienceLevel ?? 'Intermediate'} - Est. Budget: ETB ${job.budgetAmount?.toStringAsFixed(0) ?? 'Negotiable'}',
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              job.description,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 15,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.verified, color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                const Text(
                  'Payment verified',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF6B7280),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  job.location ?? 'Ethiopia',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
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
