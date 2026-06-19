# Sonner Toast Skill

Implement beautiful, accessible toast notifications in React using the Sonner library.

## When to use this skill

Use when the user wants to:
- Add toast/notification feedback to a React app
- Show success, error, warning, info, or loading states
- Display promise-based toasts (loading → success/error)
- Customize toast position, duration, styling, or actions

## Setup

```bash
npm install sonner
```

Add `<Toaster />` once at the root of your app:

```tsx
import { Toaster } from 'sonner';

function App() {
  return (
    <>
      <Toaster />
      {/* rest of your app */}
    </>
  );
}
```

## Toast types

```tsx
import { toast } from 'sonner';

toast('Default message');
toast.success('Saved successfully');
toast.error('Something went wrong');
toast.warning('Heads up!');
toast.info('Just so you know');
toast.loading('Saving...');
```

## With description

```tsx
toast.success('File uploaded', {
  description: 'your-file.pdf was saved to the cloud.',
});
```

## Promise toast

```tsx
toast.promise(saveData(), {
  loading: 'Saving...',
  success: 'Data saved!',
  error: 'Failed to save.',
});
```

## With action button

```tsx
toast('Item deleted', {
  action: {
    label: 'Undo',
    onClick: () => restoreItem(),
  },
});
```

## Toaster configuration options

```tsx
<Toaster
  position="bottom-right"       // top-left | top-right | bottom-left | bottom-right | top-center | bottom-center
  theme="system"                // light | dark | system
  richColors                    // enables colored success/error/warning/info toasts
  expand                        // show all toasts expanded by default
  duration={4000}               // ms before auto-dismiss
  visibleToasts={3}             // max toasts shown at once
  closeButton                   // show X button on each toast
/>
```

## Programmatic dismiss

```tsx
const id = toast.loading('Processing...');
// later:
toast.dismiss(id);
// or dismiss all:
toast.dismiss();
```

## Custom JSX toast

```tsx
toast(<div className="flex gap-2"><CheckIcon /> Custom content</div>);
```

## Implementation steps

1. Install: `npm install sonner`
2. Add `<Toaster />` to root layout (e.g. `app/layout.tsx` in Next.js)
3. Import `toast` in any component and call it on events
4. Choose `richColors` on `<Toaster />` for colored variants
5. Use `toast.promise()` for async operations to give loading feedback

## Tips

- In Next.js App Router, mark the component containing `<Toaster />` with `'use client'` or wrap it in a client component
- `toast.promise()` automatically transitions loading → success/error
- Use `duration={Infinity}` for toasts that stay until manually dismissed
- Custom `classNames` prop on `<Toaster />` lets you style each toast part individually
