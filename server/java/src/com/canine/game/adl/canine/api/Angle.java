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

public class Angle {

  /* Members */

  private double value;

  /* Constructors */

  public Angle(double value) {
    this.value = value;
  }

  public Angle() {
    this.value = 0.0;
  }

  public Angle(Angle other) {
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
    if (!(other0 instanceof Angle)) {
      return false;
    }
    Angle other = (Angle) other0;
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

  public static final Factory<Angle> FACTORY = new Factory<Angle>() {
    @Override
    public Angle create() {
      return new Angle();
    }

    @Override
    public Angle create(Angle other) {
      return new Angle(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Angle");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Angle> jsonBinding() {
      return Angle.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Angle> jsonBinding() {
    final JsonBinding<Double> _binding = JsonBindings.DOUBLE;
    final Factory<Angle> _factory = FACTORY;

    return new JsonBinding<Angle>() {
      @Override
      public Factory<Angle> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Angle _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public Angle fromJson(JsonElement _json) {
        return new Angle(_binding.fromJson(_json));
      }
    };
  }
}
