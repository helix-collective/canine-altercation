/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class Duration {

  /* Members */

  private double value;

  /* Constructors */

  public Duration(double value) {
    this.value = value;
  }

  public Duration() {
    this.value = 0.0;
  }

  public Duration(Duration other) {
    this.value = other.value;
  }

  /* Accessors and mutators */

  public double getValue() {
    return value;
  }

  public void setValue(double value) {
    this.value = value;
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Duration)) {
      return false;
    }
    Duration other = (Duration) other0;
    return
      value == other.value;
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + Double.valueOf(value).hashCode();
    return _result;
  }

  /* Factory for construction of generic values */

  public static final Factory<Duration> FACTORY = new Factory<Duration>() {
    @Override
    public Duration create() {
      return new Duration();
    }

    @Override
    public Duration create(Duration other) {
      return new Duration(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Duration");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Duration> jsonBinding() {
      return Duration.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Duration> jsonBinding() {
    final JsonBinding<Double> _binding = JsonBindings.DOUBLE;
    final Factory<Duration> _factory = FACTORY;

    return new JsonBinding<Duration>() {
      @Override
      public Factory<Duration> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Duration _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public Duration fromJson(JsonElement _json) {
        return new Duration(_binding.fromJson(_json));
      }
    };
  }
}
