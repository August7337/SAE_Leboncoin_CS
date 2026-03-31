import { describe } from 'vitest'

vi.mock('axios', () => {
  return {
    default: {
      get: vi.fn(() => Promise.resolve({ data: {} })),
    },
  }
})
