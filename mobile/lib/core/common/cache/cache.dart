import 'dart:async';

abstract class Cache<K, V> {
  V? get(K key);
  Future<V> fetchOrCache(K key, Future<V> Function(K key) fetch);
  void set(K key, V value);
  void clear();
}

class InMemoryCache<K, V> implements Cache<K, V> {
  InMemoryCache({
    required Duration ttl,
    DateTime Function()? nowProvider,
  })  : _ttl = ttl,
        _now = nowProvider ?? DateTime.now;

  final Duration _ttl;
  final DateTime Function() _now;
  final Map<K, _CacheEntry<V>> _entries = {};
  final Map<K, Future<V>> _pendingComputations = {};

  @override
  V? get(K key) {
    final entry = _entries[key];
    if (entry == null) {
      return null;
    }

    if (entry.expiration.isBefore(_now())) {
      _entries.remove(key);
      return null;
    }

    return entry.value;
  }

  @override
  Future<V> fetchOrCache(K key, Future<V> Function(K key) fetch) async {
    final cachedValue = get(key);
    if (cachedValue != null) {
      return cachedValue;
    }

    final existingComputation = _pendingComputations[key];
    if (existingComputation != null) {
      return existingComputation;
    }

    final Future<V> computation;
    try {
      computation = fetch(key);
    } catch (error, stackTrace) {
      return Future<V>.error(error, stackTrace);
    }

    _pendingComputations[key] = computation;

    try {
      final value = await computation;
      set(key, value);
      return value;
    } finally {
      await _pendingComputations.remove(key);
    }
  }

  @override
  void set(K key, V value) {
    _entries[key] = (
      value: value,
      expiration: _now().add(_ttl),
    );
  }

  @override
  void clear() => _entries.clear();
}

typedef _CacheEntry<V> = ({
  V value,
  DateTime expiration,
});
