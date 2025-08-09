import 'package:flutter/material.dart';
import '../models/media_content.dart';

class ContentCard extends StatelessWidget {
  final MediaContent content;

  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: content.fullPosterUrl.isNotEmpty
                  ? Image.network(
                      content.fullPosterUrl,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[300],
                          child: Icon(
                            _getIconForMediaType(content.mediaType),
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      child: Icon(
                        _getIconForMediaType(content.mediaType),
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getColorForMediaType(content.mediaType),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          content.mediaType.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          content.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (content.displayDate.isNotEmpty)
                    Text(
                      '${content.mediaType == 'tv' ? '首播' : '上映'}日期: ${content.displayDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${content.voteAverage.toStringAsFixed(1)} (${content.voteCount})',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.trending_up,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        content.popularity.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (content.mediaType == 'person' &&
                      content.knownFor != null &&
                      content.knownFor!.isNotEmpty)
                    Text(
                      '代表作品: ${content.knownFor!.take(3).join(', ')}',
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  else if (content.overview.isNotEmpty)
                    Text(
                      content.overview,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForMediaType(String mediaType) {
    switch (mediaType) {
      case 'movie':
        return Icons.movie;
      case 'tv':
        return Icons.tv;
      case 'person':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForMediaType(String mediaType) {
    switch (mediaType) {
      case 'movie':
        return Colors.blue;
      case 'tv':
        return Colors.green;
      case 'person':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
