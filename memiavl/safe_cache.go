package memiavl

import (
	"sync"

	"github.com/cosmos/iavl/cache"
)

// safeCache wraps cache.Cache with a mutex to make it thread-safe.
// This is necessary because the cache is accessed concurrently during
// snapshot reloads and queries.
type safeCache struct {
	mu    sync.RWMutex
	cache cache.Cache
}

func newSafeCache(underlying cache.Cache) cache.Cache {
	if underlying == nil {
		return nil
	}
	return &safeCache{cache: underlying}
}

func (c *safeCache) Add(node cache.Node) cache.Node {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.cache.Add(node)
}

func (c *safeCache) Get(key []byte) cache.Node {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.cache.Get(key)
}

func (c *safeCache) Has(key []byte) bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.cache.Has(key)
}

func (c *safeCache) Remove(key []byte) cache.Node {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.cache.Remove(key)
}

func (c *safeCache) Len() int {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.cache.Len()
}


