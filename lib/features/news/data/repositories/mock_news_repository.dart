import 'package:stockmark/features/news/domain/repositories/news_repository.dart';
import '../../domain/entities/news_entity.dart';

class MockNewsRepository implements NewsRepository {
  @override
  Future<List<NewsEntity>> getNews() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      // 1. OpenAI Drama
      NewsEntity(
        id: '1',
        title: 'Altman ousted from OpenAI, board says it lost confidence',
        source: 'The Wall Street Journal',
        sourceLogoUrl: 'https://logo.clearbit.com/wsj. com',
        timeAgo: '10 min ago',
        imageUrl:
            'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=200',
      ),

      // 2.  การเงิน 401(k)
      NewsEntity(
        id: '2',
        title:
            'Bipartisan bill to allow 401(k) investment in private equity introduced',
        source: 'Reuters',
        sourceLogoUrl: 'https://logo.clearbit.com/reuters.com',
        timeAgo: '1 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1611974765270-ca12586343bb?w=200',
      ),

      // 3.  Mastercard
      NewsEntity(
        id: '3',
        title:
            'Mastercard spending pulse: US retail sales rose 3.1% this holiday',
        source: 'CNBC',
        sourceLogoUrl: 'https://logo.clearbit.com/cnbc.com',
        timeAgo: '2 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1556742049-0cfed4f7a07d?w=200',
      ),

      // 4. AI Data Centers
      NewsEntity(
        id: '4',
        title:
            'Tech giants race to build new AI data centers across the globe',
        source: 'Bloomberg',
        sourceLogoUrl: 'https://logo.clearbit.com/bloomberg.com',
        timeAgo: '3 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1518770660439-4636190af475?w=200',
      ),

      // 5. Tesla
      NewsEntity(
        id: '5',
        title:
            'Tesla shares surge 15% after Elon Musk announces new Robotaxi project',
        source: 'Financial Times',
        sourceLogoUrl: 'https://logo. clearbit.com/ft.com',
        timeAgo: '4 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1617788138017-80ad40651399?w=200',
      ),

      // 6. Fed Interest Rate
      NewsEntity(
        id: '6',
        title:
            'Federal Reserve signals potential rate cuts in 2024 amid cooling inflation',
        source: 'The New York Times',
        sourceLogoUrl: 'https://logo.clearbit.com/nytimes.com',
        timeAgo: '5 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=200',
      ),

      // 7. Apple Vision Pro
      NewsEntity(
        id: '7',
        title:
            'Apple Vision Pro sales exceed expectations in first quarter launch',
        source: 'TechCrunch',
        sourceLogoUrl: 'https://logo.clearbit.com/techcrunch.com',
        timeAgo: '6 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1611532736597-de2d4265fba3?w=200',
      ),

      // 8. Bitcoin ETF
      NewsEntity(
        id: '8',
        title:
            'SEC approves first Bitcoin spot ETFs, marking historic crypto milestone',
        source: 'Bloomberg',
        sourceLogoUrl: 'https://logo.clearbit.com/bloomberg.com',
        timeAgo: '7 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1518546305927-5a555bb7020d?w=200',
      ),

      // 9.  Amazon AWS
      NewsEntity(
        id: '9',
        title:
            'Amazon AWS announces \$10 billion investment in AI infrastructure',
        source: 'Reuters',
        sourceLogoUrl: 'https://logo.clearbit.com/reuters.com',
        timeAgo: '8 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1523474253046-8cd2748b5fd2?w=200',
      ),

      // 10.  NVIDIA
      NewsEntity(
        id: '10',
        title:
            'NVIDIA becomes world\'s most valuable company, surpasses Apple',
        source: 'CNBC',
        sourceLogoUrl: 'https://logo.clearbit.com/cnbc.com',
        timeAgo: '9 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1591405351990-4726e331f141?w=200',
      ),

      // 11.  Google Gemini
      NewsEntity(
        id: '11',
        title:
            'Google launches Gemini 2.0, claims to outperform GPT-4 in benchmarks',
        source: 'The Verge',
        sourceLogoUrl: 'https://logo.clearbit.com/theverge. com',
        timeAgo: '10 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1573804633927-bfcbcd909acd?w=200',
      ),

      // 12. China Economy
      NewsEntity(
        id: '12',
        title:
            'China\'s economy grows 5.2% in 2024, beating government targets',
        source: 'Financial Times',
        sourceLogoUrl: 'https://logo. clearbit.com/ft.com',
        timeAgo: '11 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1474181487882-5abf3f0ba6c2?w=200',
      ),

      // 13.  SpaceX Starship
      NewsEntity(
        id: '13',
        title:
            'SpaceX Starship completes first successful orbital flight test',
        source: 'BBC News',
        sourceLogoUrl: 'https://logo. clearbit.com/bbc.com',
        timeAgo: '12 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1516849841032-87cbac4d88f7?w=200',
      ),

      // 14. Microsoft Copilot
      NewsEntity(
        id: '14',
        title:
            'Microsoft reports Copilot AI approach 1 billion monthly users',
        source: 'The Wall Street Journal',
        sourceLogoUrl: 'https://logo.clearbit.com/wsj.com',
        timeAgo: '13 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1633419461186-7d40a38105ec?w=200',
      ),

      // 15. Oil Prices
      NewsEntity(
        id: '15',
        title:
            'Oil prices spike to \$95 per barrel amid Middle East tensions',
        source: 'Reuters',
        sourceLogoUrl: 'https://logo.clearbit.com/reuters.com',
        timeAgo: '14 hr ago',
        imageUrl:
            'https://images.unsplash. com/photo-1474932430478-367dbb6832c1?w=200',
      ),

      // 16.  Meta Threads
      NewsEntity(
        id: '16',
        title:
            'Meta\'s Threads reaches 200 million users, challenges X platform',
        source: 'TechCrunch',
        sourceLogoUrl: 'https://logo.clearbit.com/techcrunch.com',
        timeAgo: '15 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=200',
      ),

      // 17. Bank of Japan
      NewsEntity(
        id: '17',
        title:
            'Bank of Japan ends negative interest rates for first time since 2016',
        source: 'Bloomberg',
        sourceLogoUrl: 'https://logo.clearbit.com/bloomberg.com',
        timeAgo: '16 hr ago',
        imageUrl:
            'https://images.unsplash. com/photo-1480714378408-67cf0d13bc1b?w=200',
      ),

      // 18. Samsung Galaxy AI
      NewsEntity(
        id: '18',
        title:
            'Samsung unveils Galaxy S24 with revolutionary on-device AI features',
        source: 'The Verge',
        sourceLogoUrl: 'https://logo. clearbit.com/theverge.com',
        timeAgo: '18 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1610945415295-d9bbf067e59c?w=200',
      ),

      // 19.  Walmart Drone Delivery
      NewsEntity(
        id: '19',
        title:
            'Walmart expands drone delivery to 1. 8 million US households',
        source: 'CNBC',
        sourceLogoUrl: 'https://logo.clearbit.com/cnbc.com',
        timeAgo: '20 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1473968512647-3e447244af8f?w=200',
      ),

      // 20.  EU AI Act
      NewsEntity(
        id: '20',
        title:
            'European Union passes landmark AI Act, sets global precedent for regulation',
        source: 'BBC News',
        sourceLogoUrl: 'https://logo. clearbit.com/bbc.com',
        timeAgo: '1 day ago',
        imageUrl:
            'https://images. unsplash.com/photo-1485627941502-d2e6429a8af0?w=200',
      ),
    ];
  }

  // 🔥🔥🔥 HOT NEWS - ข่าวเด่นประจำวัน 🔥🔥🔥
  @override
  Future<List<NewsEntity>> getHotNews() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      // 🔥 1.  NVIDIA ทำสถิติใหม่
      NewsEntity(
        id: 'hot_1',
        title:
            'NVIDIA stock hits all-time high as AI chip demand skyrockets to record levels',
        source: 'Bloomberg',
        sourceLogoUrl: 'https://logo.clearbit. com/bloomberg.com',
        timeAgo: '2 min ago',
        imageUrl:
            'https://images.unsplash.com/photo-1639322537228-f710d846310a?w=400',
      ),

      // 🔥 2. Fed ประกาศลดดอกเบี้ย
      NewsEntity(
        id: 'hot_2',
        title:
            'BREAKING: Federal Reserve cuts interest rates by 25 basis points',
        source: 'Reuters',
        sourceLogoUrl: 'https://logo.clearbit. com/reuters.com',
        timeAgo: '5 min ago',
        imageUrl:
            'https://images. unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400',
      ),

      // 🔥 3. Apple เปิดตัว iPhone 16
      NewsEntity(
        id: 'hot_3',
        title:
            'Apple unveils iPhone 16 Pro with revolutionary AI features and new design',
        source: 'TechCrunch',
        sourceLogoUrl: 'https://logo.clearbit. com/techcrunch.com',
        timeAgo: '15 min ago',
        imageUrl:
            'https://images. unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
      ),

      // 🔥 4. Tesla Robotaxi
      NewsEntity(
        id: 'hot_4',
        title:
            'Tesla reveals Cybercab robotaxi, plans to launch autonomous ride service in 2025',
        source: 'The Wall Street Journal',
        sourceLogoUrl: 'https://logo.clearbit.com/wsj.com',
        timeAgo: '30 min ago',
        imageUrl:
            'https://images. unsplash.com/photo-1560958089-b8a1929cea89?w=400',
      ),

      // 🔥 5. Bitcoin ทะลุ $100K
      NewsEntity(
        id: 'hot_5',
        title:
            'Bitcoin surges past \$100,000 for first time in history amid ETF inflows',
        source: 'CNBC',
        sourceLogoUrl: 'https://logo.clearbit.com/cnbc.com',
        timeAgo: '45 min ago',
        imageUrl:
            'https://images. unsplash.com/photo-1518546305927-5a555bb7020d?w=400',
      ),

      // 🔥 6. Microsoft + OpenAI
      NewsEntity(
        id: 'hot_6',
        title:
            'Microsoft announces \$50 billion investment in OpenAI partnership expansion',
        source: 'Financial Times',
        sourceLogoUrl: 'https://logo. clearbit.com/ft.com',
        timeAgo: '1 hr ago',
        imageUrl:
            'https://images.unsplash.com/photo-1677442136019-21780ecad995? w=400',
      ),

      // 🔥 7. Amazon Prime Day สถิติใหม่
      NewsEntity(
        id: 'hot_7',
        title:
            'Amazon Prime Day breaks records with \$14. 2 billion in sales worldwide',
        source: 'Bloomberg',
        sourceLogoUrl: 'https://logo.clearbit.com/bloomberg.com',
        timeAgo: '1 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1523474253046-8cd2748b5fd2?w=400',
      ),

      // 🔥 8.  SpaceX Starlink
      NewsEntity(
        id: 'hot_8',
        title:
            'SpaceX Starlink reaches 5 million subscribers, expands to 100 countries',
        source: 'The Verge',
        sourceLogoUrl: 'https://logo.clearbit. com/theverge.com',
        timeAgo: '2 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1516849841032-87cbac4d88f7?w=400',
      ),

      // 🔥 9.  Google ชนะคดี AI
      NewsEntity(
        id: 'hot_9',
        title:
            'Google wins major AI copyright lawsuit, sets precedent for tech industry',
        source: 'The New York Times',
        sourceLogoUrl: 'https://logo.clearbit.com/nytimes. com',
        timeAgo: '2 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1573804633927-bfcbcd909acd?w=400',
      ),

      // 🔥 10.  Saudi Aramco + AI
      NewsEntity(
        id: 'hot_10',
        title:
            'Saudi Aramco partners with NVIDIA to build largest AI computing center',
        source: 'Reuters',
        sourceLogoUrl: 'https://logo.clearbit.com/reuters.com',
        timeAgo: '3 hr ago',
        imageUrl:
            'https://images. unsplash.com/photo-1518770660439-4636190af475?w=400',
      ),
    ];
  }
}
