#include <aeraui/runner.hpp>
#include <aeraui/display_transform.hpp>
#include <cassert>

int main() {
  constexpr auto metrics = aeraui::DisplayMetrics::FromThemeMetrics(true, 2376, 120);
  static_assert(metrics.logical_height == 3168);
  const auto transform = aeraui::DisplayTransform::Adaptive(1440, 3168, metrics.logical_height);
  assert(transform.IsValid());
  assert(!transform.IsScaled());
  assert(transform.ToLogicalX(720) == 720);
  assert(transform.ToLogicalY(1584) == 1584);
  assert(transform.ToLogicalX(1439) == 1439);
  assert(transform.ToLogicalY(3167) == 3167);
}
