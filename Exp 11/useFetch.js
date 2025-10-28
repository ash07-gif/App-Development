import { useCallback, useRef, useState } from 'react';

export function useFetch() {
  const cacheRef = useRef(null);
  const [status, setStatus] = useState('idle'); // idle | loading | success | error
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  const execute = useCallback(async (fn, { force = false } = {}) => {
    setStatus('loading');
    setError(null);

    if (!force && cacheRef.current) {
      setData(cacheRef.current);
      setStatus('success');
      return cacheRef.current;
    }

    try {
      const result = await fn();
      cacheRef.current = result;
      setData(result);
      setStatus('success');
      return result;
    } catch (err) {
      const message = err?.message ?? 'Unknown error';
      setError(message);
      setStatus('error');
      throw err;
    }
  }, []);

  const clearCache = useCallback(() => {
    cacheRef.current = null;
    setData(null);
    setStatus('idle');
    setError(null);
  }, []);

  return { execute, data, status, error, clearCache };
}
