package com.codegym;

/** Giải phương trình ax² + bx + c = 0. */
public final class QuadraticEquation {
    private static final double EPSILON = 1e-10;

    private QuadraticEquation() {
    }

    public static Result solve(double a, double b, double c) {
        if (Math.abs(a) < EPSILON) {
            if (Math.abs(b) < EPSILON) {
                return Math.abs(c) < EPSILON ? Result.infinite() : Result.none();
            }
            return Result.one(-c / b);
        }

        double delta = b * b - 4 * a * c;
        if (delta < -EPSILON) {
            return Result.none();
        }
        if (Math.abs(delta) <= EPSILON) {
            return Result.one(-b / (2 * a));
        }

        double sqrtDelta = Math.sqrt(delta);
        return Result.two((-b + sqrtDelta) / (2 * a), (-b - sqrtDelta) / (2 * a));
    }

    public static final class Result {
        public enum Type { NONE, ONE_ROOT, TWO_ROOTS, INFINITE }

        private final Type type;
        private final double firstRoot;
        private final double secondRoot;

        private Result(Type type, double firstRoot, double secondRoot) {
            this.type = type;
            this.firstRoot = firstRoot;
            this.secondRoot = secondRoot;
        }

        public static Result none() { return new Result(Type.NONE, Double.NaN, Double.NaN); }
        public static Result one(double root) { return new Result(Type.ONE_ROOT, root, root); }
        public static Result two(double first, double second) { return new Result(Type.TWO_ROOTS, first, second); }
        public static Result infinite() { return new Result(Type.INFINITE, Double.NaN, Double.NaN); }

        public Type getType() { return type; }
        public double getFirstRoot() { return firstRoot; }
        public double getSecondRoot() { return secondRoot; }

        @Override
        public String toString() {
            switch (type) {
                case ONE_ROOT: return "Phương trình có một nghiệm: x = " + firstRoot;
                case TWO_ROOTS: return "Phương trình có hai nghiệm: x1 = " + firstRoot + ", x2 = " + secondRoot;
                case INFINITE: return "Phương trình có vô số nghiệm";
                default: return "Phương trình vô nghiệm";
            }
        }
    }
}
