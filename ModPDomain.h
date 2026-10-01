#pragma once

#include "llvm/Support/raw_ostream.h"

namespace modp {

enum class Kind { Bottom, Concrete, Top };

template <unsigned P> struct ModPState {
  static_assert(P >= 2, "modulus must be at least 2");

  Kind kind = Kind::Bottom;
  // Only meaningful when kind == Concrete.
  unsigned remainder = 0;

  ModPState() = default;
  ModPState(Kind kind) : kind(kind) {}
  explicit ModPState(unsigned remainder)
      : kind(Kind::Concrete), remainder(remainder % P) {}

  static ModPState bottom() { return Kind::Bottom; }
  static ModPState top() { return Kind::Top; }

  bool isBottom() const { return kind == Kind::Bottom; }
  bool isTop() const { return kind == Kind::Top; }

  static ModPState join(const ModPState &lhs, const ModPState &rhs) {
    if (lhs.isBottom())
      return rhs;
    if (rhs.isBottom())
      return lhs;
    if (lhs == rhs)
      return lhs;
    return top();
  }

  static ModPState add(const ModPState &lhs, const ModPState &rhs) {
    if (lhs.isBottom() || rhs.isBottom())
      return bottom();
    if (lhs.isTop() || rhs.isTop())
      return top();
    return ModPState(lhs.remainder + rhs.remainder);
  }

  bool operator==(const ModPState &other) const {
    if (kind != other.kind)
      return false;
    return kind != Kind::Concrete || remainder == other.remainder;
  }

  bool operator!=(const ModPState &other) const { return !(*this == other); }

  void print(llvm::raw_ostream &os) const {
    if (isBottom())
      os << "bottom";
    else if (isTop())
      os << "top";
    else
      os << remainder << " (mod " << P << ")";
  }

  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &os,
                                       const ModPState &state) {
    state.print(os);
    return os;
  }
};

} // namespace modp
