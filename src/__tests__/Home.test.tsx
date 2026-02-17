import { render, screen } from '@testing-library/react';
import Home from '@/components/Home';

test('Home component renders welcome text', () => {
  render(<Home />);
  expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent(/Welcome to BallotBuilder/i);
});
