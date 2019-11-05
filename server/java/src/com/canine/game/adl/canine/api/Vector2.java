/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class Vector2 {

  /* Members */

  private double x;
  private double y;

  /* Constructors */

  public Vector2(double x, double y) {
    this.x = x;
    this.y = y;
  }

  public Vector2() {
    this.x = 0.0;
    this.y = 0.0;
  }

  public Vector2(Vector2 other) {
    this.x = other.x;
    this.y = other.y;
  }

  /* Accessors and mutators */

  public double getX() {
    return x;
  }

  public void setX(double x) {
    this.x = x;
  }

  public double getY() {
    return y;
  }

  public void setY(double y) {
    this.y = y;
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Vector2)) {
      return false;
    }
    Vector2 other = (Vector2) other0;
    return
      x == other.x &&
      y == other.y;
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + Double.valueOf(x).hashCode();
    _result = _result * 37 + Double.valueOf(y).hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder {
    private Double x;
    private Double y;

    public Builder() {
      this.x = null;
      this.y = null;
    }

    public Builder setX(Double x) {
      this.x = Objects.requireNonNull(x);
      return this;
    }

    public Builder setY(Double y) {
      this.y = Objects.requireNonNull(y);
      return this;
    }

    public Vector2 create() {
      Builders.checkFieldInitialized("Vector2", "x", x);
      Builders.checkFieldInitialized("Vector2", "y", y);
      return new Vector2(x, y);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<Vector2> FACTORY = new Factory<Vector2>() {
    @Override
    public Vector2 create() {
      return new Vector2();
    }

    @Override
    public Vector2 create(Vector2 other) {
      return new Vector2(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Vector2");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Vector2> jsonBinding() {
      return Vector2.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Vector2> jsonBinding() {
    final Lazy<JsonBinding<Double>> x = new Lazy<>(() -> JsonBindings.DOUBLE);
    final Lazy<JsonBinding<Double>> y = new Lazy<>(() -> JsonBindings.DOUBLE);
    final Factory<Vector2> _factory = FACTORY;

    return new JsonBinding<Vector2>() {
      @Override
      public Factory<Vector2> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Vector2 _value) {
        JsonObject _result = new JsonObject();
        _result.add("x", x.get().toJson(_value.x));
        _result.add("y", y.get().toJson(_value.y));
        return _result;
      }

      @Override
      public Vector2 fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new Vector2(
          JsonBindings.fieldFromJson(_obj, "x", x.get()),
          JsonBindings.fieldFromJson(_obj, "y", y.get())
        );
      }
    };
  }
}
